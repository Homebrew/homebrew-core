class Cmocka < Formula
  desc "Unit testing framework for C"
  homepage "https://cmocka.org/"
  url "https://cmocka.org/files/1.1/cmocka-1.1.5.tar.xz"
  sha256 "f0ccd8242d55e2fd74b16ba518359151f6f8383ff8aef4976e48393f77bba8b6"
  license "Apache-2.0"
  head "https://git.cryptomilk.org/projects/cmocka.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a504b57668ab63e04fd3ca656d6a0a48a215779b9779dad64e6e65e56441c2fd"
    sha256 cellar: :any,                 arm64_big_sur:  "e2ed51c48c56006bb4b8591259eb206968e46457e78b15570c567d990b5f97d3"
    sha256 cellar: :any,                 monterey:       "221d35e014f83b7ba5c115ed5dc058508f956ff551141676a13ece2be1c476a3"
    sha256 cellar: :any,                 big_sur:        "a852c9033a2ca9543dff361a5a5d19027dddab7d207e9a080cf9f8bf75751354"
    sha256 cellar: :any,                 catalina:       "719b81c50a85d95dfc0bdd88b52e5642cc81e22f95776fc8d92065217bef879e"
    sha256 cellar: :any,                 mojave:         "a05bfdbe08b08dc01db59d0c2c724b2a58c4f9e12c260dc5865e27dd456e7771"
    sha256 cellar: :any,                 high_sierra:    "c4fc9fe8a73b23206c0db8907c2f67dea482d689afea18c5e746556aff8098b5"
    sha256 cellar: :any,                 sierra:         "a8d32491c7cfd1670be11c022faa07619d7821a4328fb034e76f225933b5c4dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f6e5f5ffe5cdf0605d128b361f338ae8f986d7fbd5713681c07747738ff4266"
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
