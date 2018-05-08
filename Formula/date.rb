class Date < Formula
  desc "C++11/14/17 library for Date and Time operations based on <chrono> header"
  homepage "https://github.com/HowardHinnant/date"
  url "https://github.com/HowardHinnant/date/archive/v2.4.1.tar.gz"
  sha256 "98907d243397483bd7ad889bf6c66746db0d7d2a39cc9aacc041834c40b65b98"

  option "with-system-tz-db", "Use the operating system's timezone database"
  option "without-shared", "Build a static version of library"

  depends_on "cmake" => :build

  def install
    custom_cmake_args = ["-DENABLE_DATE_TESTING=OFF"]

    if build.with? "system-tz-db"
      custom_cmake_args << "-DUSE_SYSTEM_TZ_DB=ON"
    else
      custom_cmake_args << "-DUSE_SYSTEM_TZ_BD=OFF"
    end

    if build.without? "shared"
      arcustom_cmake_argsgs << "-DBUILD_SHARED_LIBS=OFF"
    else
      custom_cmake_args << "-DBUILD_SHARED_LIBS=ON"
    end

    system "cmake", ".", *std_cmake_args, *custom_cmake_args
    system "make", "-j#{ENV.make_jobs}"
    system "make", "install"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test date`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
