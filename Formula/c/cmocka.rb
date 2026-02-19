class Cmocka < Formula
  desc "Unit testing framework for C"
  homepage "https://cmocka.org/"
  url "https://cmocka.org/files/2.0/cmocka-2.0.2.tar.xz"
  sha256 "39f92f366bdf3f1a02af4da75b4a5c52df6c9f7e736c7d65de13283f9f0ef416"
  license "Apache-2.0"
  head "https://git.cryptomilk.org/projects/cmocka.git", branch: "master"

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1526e9b10b209071770801428c41d08bf7f8601f23dce9b93ee03260dd419529"
    sha256 cellar: :any,                 arm64_sequoia: "920260e22db9b96a6bfba2c54b48286b66b654680c37067099478abdce4a472d"
    sha256 cellar: :any,                 arm64_sonoma:  "e2c2de2b3ade844e2b765b495c82e73e540fa0262fdaa5959f2104223310fd7b"
    sha256 cellar: :any,                 sonoma:        "44075b56a67f29c890e88e9711337a48a4212b598998641c985f1d2a8e42e0be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b436e2a03af8a0666e671ab970a16da1c40981de1bfeeb27dbb344cf39ba533c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3509a180a3d4d2dba82c53c2ff8465c07196ddede5298f316cd8a9540f70037d"
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
