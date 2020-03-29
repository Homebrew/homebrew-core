class Cmocka < Formula
  desc "Unit testing framework for C"
  homepage "https://cmocka.org/"
  url "https://cmocka.org/files/1.1/cmocka-1.1.5.tar.xz"
  sha256 "f0ccd8242d55e2fd74b16ba518359151f6f8383ff8aef4976e48393f77bba8b6"
  head "https://git.cryptomilk.org/projects/cmocka.git"

  bottle do
    cellar :any
    sha256 "719b81c50a85d95dfc0bdd88b52e5642cc81e22f95776fc8d92065217bef879e" => :catalina
    sha256 "a05bfdbe08b08dc01db59d0c2c724b2a58c4f9e12c260dc5865e27dd456e7771" => :mojave
    sha256 "c4fc9fe8a73b23206c0db8907c2f67dea482d689afea18c5e746556aff8098b5" => :high_sierra
    sha256 "a8d32491c7cfd1670be11c022faa07619d7821a4328fb034e76f225933b5c4dc" => :sierra
  end

  depends_on "cmake" => :build

  def install
    args = std_cmake_args
    args << "-DWITH_STATIC_LIB=ON" << "-DWITH_CMOCKERY_SUPPORT=ON" << "-DUNIT_TESTING=ON"
    args << "-DHAVE_CLOCK_GETTIME:INTERNAL=0" if MacOS.version == "10.11" && MacOS::Xcode.version >= "8.0"

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
