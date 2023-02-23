class Cmocka < Formula
  desc "Unit testing framework for C"
  homepage "https://cmocka.org/"
  url "https://cmocka.org/files/1.1/cmocka-1.1.7.tar.xz"
  sha256 "810570eb0b8d64804331f82b29ff47c790ce9cd6b163e98d47a4807047ecad82"
  license "Apache-2.0"
  head "https://git.cryptomilk.org/projects/cmocka.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "10d26bf899a3f81117ff42367d0dd11d1519e3f146d63341c5c87e89a42e983e"
    sha256 cellar: :any,                 arm64_monterey: "01113968fe6423bef882def55d8db208c5f5ae527b5a508f8f58f1ced15990a8"
    sha256 cellar: :any,                 arm64_big_sur:  "c6efe7c74fe398d438be12f5e8e27dd334ecbabc4fbb5746c615754526df519a"
    sha256 cellar: :any,                 ventura:        "cc1c7cbc44a6a23aac1dee4c14702eac7ef3a56835a1dc381f0ea18dbe3c306f"
    sha256 cellar: :any,                 monterey:       "7ca0cd56fe2a9cc06d639f627612fb5292052131465503db15e4689ddaa09e61"
    sha256 cellar: :any,                 big_sur:        "16476a114556a1e6abf8494c111ec345f6020e1a33f3cc4183f05c41fcf40cc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a1e0e2240ed1b163dca04fe01532343d88833957fad05e80df1d8572a67ba16"
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
