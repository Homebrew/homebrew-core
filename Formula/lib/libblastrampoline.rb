class Libblastrampoline < Formula
  desc "Using PLT trampolines to provide a BLAS and LAPACK demuxing library"
  homepage "https://github.com/JuliaLinearAlgebra/libblastrampoline"
  url "https://github.com/JuliaLinearAlgebra/libblastrampoline/archive/refs/tags/v5.12.0.tar.gz"
  sha256 "12f9d186bc844a21dfa2a6ea1f38a039227554330c43230d72f721c330cf6018"
  license all_of: [
    "MIT",
    "BSD-2-Clause-Views", # include/common/f77blas.h
    "BSD-3-Clause",       # include/common/lapacke*
  ]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a41f25d661d33658eec04d2a320c20e885db2ad5bcdbcb30ef62e7c41d534ceb"
    sha256 cellar: :any,                 arm64_sonoma:  "e3816dc15789f1b23444a81fa39e2f143de139244c42df036df1bdf713df4ca3"
    sha256 cellar: :any,                 arm64_ventura: "1cdd282eb257880f3b04ae12ac6715bc4407bf49b14dc4ae4a190755840f4de9"
    sha256 cellar: :any,                 sonoma:        "b8eb22f07216cfc835aad8f48ac29fdb19ed2dfb162f5c2559f56bbe15c46ce3"
    sha256 cellar: :any,                 ventura:       "ee9c185e49e8f405ba2335f661593d3838130b6a20415143a7984f0d0af21f1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5bd84148c9d508220b588ef6eaf80e82dbf1ede283221de412b1c9fac52824b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8df6fd7523f579b6110937096f0b9d21d430fffc0924cdc1f742364c94d88a84"
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
