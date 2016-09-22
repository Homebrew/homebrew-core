class Cmocka < Formula
  desc "Unit testing framework for C"
  homepage "https://cmocka.org/"
  url "https://cmocka.org/files/1.1/cmocka-1.1.0.tar.xz"
  sha256 "e960d3bf1be618634a4b924f18bb4d6f20a825c109a8ad6d1af03913ba421330"

  bottle do
    cellar :any
    sha256 "df6195f9a7d312247e0a98cca755216d970a5131d8c6482094ef516c97b9dcd0" => :el_capitan
    sha256 "33765424588cf149679e394842f6132dbb003913e774bc30d0115294952c3cad" => :yosemite
    sha256 "28ea3d6de51e920dae544f9b4f36288a04f1ee6215dd34f833c6e98bc43de0f9" => :mavericks
    sha256 "544f9a2bd42b2a868322cc9942afb191733260bb33e8a2731a53311b6c538d7d" => :mountain_lion
  end

  depends_on "cmake" => :build

  def install
    args = std_cmake_args
    if MacOS.version == "10.11" && MacOS::Xcode.installed? && MacOS::Xcode.version >= "8.0"
      args << "-DHAVE_CLOCK_GETTIME:INTERNAL=0"
    end

    mkdir "build" do
      system "cmake", "..", "-DUNIT_TESTING=On", *args
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
