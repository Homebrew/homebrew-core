class Cmocka < Formula
  desc "Unit testing framework for C"
  homepage "https://cmocka.org/"
  url "https://cmocka.org/files/1.1/cmocka-1.1.7.tar.xz"
  sha256 "810570eb0b8d64804331f82b29ff47c790ce9cd6b163e98d47a4807047ecad82"
  license "Apache-2.0"
  head "https://git.cryptomilk.org/projects/cmocka.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "59ce3786b76ea0bad5cf63974c4c341a967f562f6beeebac2714b9a6cdb8ee69"
    sha256 cellar: :any,                 arm64_monterey: "655c370c95261b0a2497884db61e2d93e016b3ac12c895bd177c4937fe8382b9"
    sha256 cellar: :any,                 arm64_big_sur:  "f834bde77c929e72148871eb2ebb902b6f746fc5c80581027ac3e2c8eba4e695"
    sha256 cellar: :any,                 ventura:        "1af6df21cc146d414b8c6b03b995cb99e18ee020efcf34c6be4f2724684797ad"
    sha256 cellar: :any,                 monterey:       "b5120aab3d6d5daf7a4166c0bd95b622d057bdc519ce9d8792ac3174effcec26"
    sha256 cellar: :any,                 big_sur:        "4bdc48b2707b15f13d671f193de414f70a905e4a6e62e7f3ad823c0e01ec9f13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3ac6a9be93cbd9ff420c38ff86c3c5559fe2ab584423f8bddd04c77f7235ab3"
  end

  depends_on "cmake" => :build

  def install
    args = std_cmake_args
    args << "-DWITH_STATIC_LIB=ON" << "-DWITH_CMOCKERY_SUPPORT=ON" << "-DUNIT_TESTING=ON"

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
