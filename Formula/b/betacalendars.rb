class Betacalendars < Formula
  desc "Generate and validate Gregorian calendar grids and print layouts"
  homepage "https://www.betacalendars.com/"
  url "https://github.com/mateopedersen/betacalendars-calendar-layout/archive/6b303e7f1f258d0754951a4827343fa351facf30.tar.gz"
  version "0.2.0"
  sha256 "c245cebaaf8caa9445518b4ba3490292ddec53c5e7bf122832f1372e6e273120"
  license "MIT"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DBETACALENDARS_BUILD_TOOLS=ON"
    system "cmake", "--build", "build", "--parallel"
    system "cmake", "--install", "build"
  end

  test do
    february = shell_output("#{bin}/betacal month --year 2027 --month 2 --week-start monday --format json")
    assert_match '"year":2027', february
    assert_match '"month":2', february
    assert_match '"rows":4', february
    assert_equal 28, february.scan('"relation":"current_month"').length

    year = shell_output("#{bin}/betacal year --year 2027 --format json")
    assert_match '"days":365', year

    boundary = shell_output("#{bin}/betacal inspect --year 2026 --format json")
    assert_match '"date":"2026-12-31","weekday":"Thursday"', boundary
    assert_match '"date":"2027-01-01","weekday":"Friday"', boundary
    assert_match '"weekday_continues":true', boundary

    blank = shell_output("#{bin}/betacal blank --rows 6 --paper a4 --orientation landscape --format svg")
    assert_match "<svg ", blank
  end
end
