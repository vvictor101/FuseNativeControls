using Uno;
using Uno.Text;
using Uno.Data.Json;
using Uno.UX;
using Uno.Time;

using Fuse;
using Fuse.Controls;
using Fuse.Controls.Native;
using Fuse.Scripting;

namespace Native
{

	public partial class DatePicker
	{

		static DatePicker()
		{
			ScriptClass.Register(typeof(DatePicker),
				new ScriptMethod<DatePicker>("setDate", setDate, ExecutionThread.MainThread),
				new ScriptMethod<DatePicker>("setMinDate", setMinDate, ExecutionThread.MainThread),
				new ScriptMethod<DatePicker>("setMaxDate", setMaxDate, ExecutionThread.MainThread));
		}

		static void setDate(Context context, DatePicker datePicker, object[] args)
		{
			var localDate = ArgsToLocalDate(args);
			var dp = datePicker.DatePickerView;
			if (dp != null)
				dp.CurrentDate = localDate;
		}

		static void setMinDate(Context context, DatePicker datePicker, object[] args)
		{
			var localDate = ArgsToLocalDate(args);
			var dp = datePicker.DatePickerView;
			if (dp != null)
				dp.MinDate = localDate;
		}

		static void setMaxDate(Context context, DatePicker datePicker, object[] args)
		{
			var localDate = ArgsToLocalDate(args);
			var dp = datePicker.DatePickerView;
			if (dp != null)
				dp.MaxDate = localDate;
		}

		static LocalDate ArgsToLocalDate(object[] args)
		{
			if (args.Length < 1)
				throw new Fuse.Scripting.Error("Missing argument");

			var obj = args[0] as Fuse.Scripting.Object;
			if (obj == null)
				throw new Fuse.Scripting.Error("Argument must be an object with year, month and date");

			if (!obj.ContainsKey("year"))
				throw new Fuse.Scripting.Error("year missing from argument");

			if (!obj.ContainsKey("month"))
				throw new Fuse.Scripting.Error("month missing from argument");

			if (!obj.ContainsKey("day"))
				throw new Fuse.Scripting.Error("day missing from argument");

			return new LocalDate(
				Marshal.ToInt(obj["year"]),
				Marshal.ToInt(obj["month"]),
				Marshal.ToInt(obj["day"]));
		}

	}

	internal static class DateExtensions
	{
		public static string ToJSON(this LocalDate localDate)
		{
			return string.Format(
				"{ year:{0}, month:{1}, day:{2} }",
				localDate.Year,
				localDate.Month,
				localDate.Day);
		}

		public static LocalDate FromJSON(this JsonReader json)
		{
			var year = json["year"].AsInteger();
			var month = json["month"].AsInteger();
			var day = json["day"].AsInteger();
			return new LocalDate(year, month, day);
		}

	}

}