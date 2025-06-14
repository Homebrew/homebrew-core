class Libblastrampoline < Formula
  desc "Using PLT trampolines to provide a BLAS and LAPACK demuxing library"
  homepage "https://github.com/JuliaLinearAlgebra/libblastrampoline"
  url "https://github.com/JuliaLinearAlgebra/libblastrampoline/archive/refs/tags/v5.13.0.tar.gz"
  sha256 "45a73ab0e112df142d37117cd78a53c5d9b3ffd86a5f151d3103ec2274600364"
  license all_of: [
    "MIT",
    "BSD-2-Clause-Views", # include/common/f77blas.h
    "BSD-3-Clause",       # include/common/lapacke*
  ]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "43ccaf3f8b60d62df19f7aa6cb2147524dbcad2b743391629e8afcc807e2ed08"
    sha256 cellar: :any,                 arm64_sonoma:  "e17e7d1aafc744c300df2543e2f7791f659feb4bcc191a869145617e799bf94f"
    sha256 cellar: :any,                 arm64_ventura: "9817ded0c469cc89c533e77acaff0312c8cf43505225b4c38103121dbfd29b52"
    sha256 cellar: :any,                 sonoma:        "6d059e97c5c3ee668c153b304162f053ff46e30557beaac3204950d07e17984b"
    sha256 cellar: :any,                 ventura:       "7358510d10d8ec9e53496fe0e74a8197db0c7dfeaa6b2346f56a53fb6587c42f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97935472f38aa55f201b5fb5065dd432f6f7efe15b1dc08159d37d9446186db6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b68aeb24b65b535907b939721660d166275cd14046758f77853518e7b513510"
  end

  depends_on "openblas" => :test

  # Apply commit from open PR to fix build with Xcode 16+ / LLVM 17+
  # PR ref: https://github.com/JuliaLinearAlgebra/libblastrampoline/pull/148
  patch do
    url "https://github.com/JuliaLinearAlgebra/libblastrampoline/commit/c7e71924f47f4d016afe7ef994e30b46080ac918.patch?full_index=1"
    sha256 "320360db93fe46e52ee21e8b817752ec3b1717b64a0f33b45617bcc6dfa206ae"
  end

  def install
    system "make", "-C", "src", "install", "prefix=#{prefix}"
    (pkgshare/"test").install "test/dgemm_test/dgemm_test.c"
  end

  test do
    cp pkgshare/"test/dgemm_test.c", testpath

    (testpath/"api_test.c").write <<~C
      #include <assert.h>
      #include <stdio.h>
      #include <libblastrampoline.h>

      int main() {
        const lbt_config_t * config = lbt_get_config();
        assert(config != NULL);

        lbt_library_info_t ** libs = config->loaded_libs;
        assert(libs != NULL);
        assert(sizeof(libs) == sizeof(lbt_library_info_t *));
        assert(libs[0] != NULL);

        printf("%s", libs[0]->libname);
        return 0;
      }
    C

    system ENV.cc, "dgemm_test.c", "-I#{include}", "-L#{lib}", "-lblastrampoline", "-o", "dgemm_test"
    system ENV.cc, "api_test.c", "-I#{include}", "-L#{lib}", "-lblastrampoline", "-o", "api_test"

    test_libs = [shared_library("libopenblas")]
    if OS.mac?
      test_libs << "/System/Library/Frameworks/Accelerate.framework/Accelerate"
      ENV["DYLD_LIBRARY_PATH"] = Formula["openblas"].opt_lib.to_s
    end

    test_libs.each do |test_lib|
      with_env(LBT_DEFAULT_LIBS: test_lib) do
        assert_equal test_lib, shell_output("./api_test")
        system "./dgemm_test"
      end
    end
  end
end
