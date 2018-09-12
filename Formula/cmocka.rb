class Cmocka < Formula
  desc "Unit testing framework for C"
  homepage "https://cmocka.org/"
  url "https://cmocka.org/files/1.1/cmocka-1.1.2.tar.xz"
  sha256 "d11cd1e129827ff240a501c1c43557e808de89e8fcd8ab9e963c8db419332bdd"
  head "https://git.cryptomilk.org/projects/cmocka.git"

  bottle do
    cellar :any
    sha256 "e10afaac3754fb32bdefb16ebde9873f2c3df8f26b821345c5b8e4ce1a3bfc19" => :mojave
    sha256 "c6c4e7501378c12f36ee6018178b0083d17bc69fe2cc40e07107b72b9fe12391" => :high_sierra
    sha256 "06424efd3a7383a55524c08b61408542920469dcecebf27c6b73d7f609dc4bbe" => :sierra
    sha256 "6ac37854fdbba60081e67cc10c63fb18fc6c03a2cbf1dd4ca87fe819d18455b6" => :el_capitan
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
