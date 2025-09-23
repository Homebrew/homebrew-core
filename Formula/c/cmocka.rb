class Cmocka < Formula
  desc "Unit testing framework for C"
  homepage "https://cmocka.org/"
  url "https://cmocka.org/files/1.1/cmocka-1.1.8.tar.xz"
  sha256 "58435b558766d7f4c729ba163bdf3aec38bed3bc766dab684e3526ed0aa7c780"
  license "Apache-2.0"
  head "https://git.cryptomilk.org/projects/cmocka.git", branch: "master"

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fd067cb88fba94b330304b9f20529a3188486cfd9404e670562f8193c9016ab7"
    sha256 cellar: :any,                 arm64_sequoia: "9c21cefd986895363495212fe84bb3d5709aebb98626758c2b740b823105034c"
    sha256 cellar: :any,                 arm64_sonoma:  "c43364a4f0f426476007f0afce352c2648465f3e728f6ecf6a9005afc743bf14"
    sha256 cellar: :any,                 arm64_ventura: "4a6cc1b109d9339b23d43814ce6fe2ee9aa91d1e4870833a1912d9ce27d00760"
    sha256 cellar: :any,                 sonoma:        "cf789d33088219b798f05cef3b6a1409d71631a4a407e290b3c306adde8aad23"
    sha256 cellar: :any,                 ventura:       "75ebb525e7d69931007433bb05779454d23fe4a85bc848c6885a8200333fa3b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6256a27596e358ee8cd3a9be47564820e92f096853bede4ef3000c1381e435ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5315f47810674b24ac96c441e67ae317c34ca4656520de3292ed810d5d1a8d2"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DWITH_STATIC_LIB=ON
      -DWITH_CMOCKERY_SUPPORT=ON
      -DUNIT_TESTING=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcmocka", "-o", "test"
    system "./test"
  end
end
