class Cmocka < Formula
  desc "Unit testing framework for C"
  homepage "https://cmocka.org/"
  url "https://cmocka.org/files/1.1/cmocka-1.1.3.tar.xz"
  sha256 "43eabcf72a9c80e3d03f7c8a1c04e408c18d2db5121eb058a3ef732a9dfabfaf"
  head "https://git.cryptomilk.org/projects/cmocka.git"

  bottle do
    cellar :any
    sha256 "4f2dda00b968d99edbd3bd2aa3143ea7dd2ff37972f7e607cb4063ac059684c6" => :mojave
    sha256 "d304c4817bc9efe26cf406ce282ded888b4364be6d0752ddb3012542ae384a52" => :high_sierra
    sha256 "d888978c74742f86fee309289e99b9eaa379cf5c9c2692ad668021e5fa3213a4" => :sierra
  end

  depends_on "cmake" => :build

  def install
    args = std_cmake_args
    args << "-DWITH_STATIC_LIB=ON" << "-DWITH_CMOCKERY_SUPPORT=ON" << "-DUNIT_TESTING=ON"
    if MacOS.version == "10.11" && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      args << "-DHAVE_CLOCK_GETTIME:INTERNAL=0"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdarg.h>
      #include <stddef.h>
      #include <setjmp.h>
      #include <cmocka.h>

      static void null_test_success(void **state) {
        (void) state; /* unused */
      }

      int main(void) {
        const struct CMUnitTest tests[] = {
            cmocka_unit_test(null_test_success),
        };
        return cmocka_run_group_tests(tests, NULL, NULL);
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcmocka", "-o", "test"
    system "./test"
  end
end
