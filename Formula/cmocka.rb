class Cmocka < Formula
  desc "Unit testing framework for C"
  homepage "https://cmocka.org/"
  url "https://cmocka.org/files/1.1/cmocka-1.1.0.tar.xz"
  sha256 "e960d3bf1be618634a4b924f18bb4d6f20a825c109a8ad6d1af03913ba421330"

  bottle do
    cellar :any
    sha256 "9ae0c0b36d7b8be3fb1847cf22434a7824cc19ed068e7b25af2967c1f0854890" => :sierra
    sha256 "df6dcdbd93b8cc1ec973f869aa55bfe04434d2ee205a0a61fa4a568ed73c1d72" => :el_capitan
    sha256 "ee52eab67b7f24ced2106764e6baf90b37f5011cb398d920b8040835d4760206" => :yosemite
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
    (testpath/"test.c").write <<-EOS.undent
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
