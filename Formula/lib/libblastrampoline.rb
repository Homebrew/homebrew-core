class Libblastrampoline < Formula
  desc "Using PLT trampolines to provide a BLAS and LAPACK demuxing library"
  homepage "https://github.com/JuliaLinearAlgebra/libblastrampoline"
  url "https://github.com/JuliaLinearAlgebra/libblastrampoline/archive/refs/tags/v5.11.0.tar.gz"
  sha256 "4ea6c134843bd868f78d7ee0c61bf8bdda5334f20deaa6d3cd5bc6caafc4af17"
  license all_of: [
    "MIT",
    "BSD-2-Clause-Views", # include/common/f77blas.h
    "BSD-3-Clause",       # include/common/lapacke*
  ]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "c5952ef8dabfcddceaf5c9397f17538260d7592282f806e6eaf0125d1f35091b"
    sha256 cellar: :any,                 arm64_sonoma:   "70c25f76601949269e21048be82f671ca0d97bf5b71c11eddae338b3916b198f"
    sha256 cellar: :any,                 arm64_ventura:  "51cee0c324df3077f746332e9a428d0ca1b7d81faab257e371b2d92147b02973"
    sha256 cellar: :any,                 arm64_monterey: "254d9acb9cfb8be58703c06e621cd4df120bac6c1464eb6bdc73325b0e3002d8"
    sha256 cellar: :any,                 sonoma:         "48f2f7813d5b7c04267e924fed7ba578acb8e4e139d70df80a2dc8cb4ebbfdd7"
    sha256 cellar: :any,                 ventura:        "84e50ef11eb134a5822d1f765f91ce8235c6ff675020b3bc33a8b6951b0f64c9"
    sha256 cellar: :any,                 monterey:       "f3fb195e78ad38bdcdf6d5e68f3290e72ff435d85a9bc9052f5db1bd4bcccfa5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b45c0f742c4f3699842d75b19438efc8a49816ab82b46352a4a197ce63fed42"
  end

  depends_on "openblas" => :test

  on_macos do
    # Work around build failure seen with Xcode 16 and LLVM 17-18.
    # Issue ref: https://github.com/JuliaLinearAlgebra/libblastrampoline/issues/139
    depends_on "llvm@16" => :build if DevelopmentTools.clang_build_version == 1600
  end

  def install
    # Compiler selection is not supported for versioned LLVM
    ENV["HOMEBREW_CC"] = Formula["llvm@16"].opt_bin/"clang" if DevelopmentTools.clang_build_version == 1600

    system "make", "-C", "src", "install", "prefix=#{prefix}"
    (pkgshare/"test").install "test/dgemm_test/dgemm_test.c"
  end

  test do
    cp pkgshare/"test/dgemm_test.c", testpath

    (testpath/"api_test.c").write <<~EOS
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
    EOS

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
