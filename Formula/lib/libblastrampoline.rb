class Libblastrampoline < Formula
  desc "Using PLT trampolines to provide a BLAS and LAPACK demuxing library"
  homepage "https://github.com/JuliaLinearAlgebra/libblastrampoline"
  url "https://github.com/JuliaLinearAlgebra/libblastrampoline/archive/refs/tags/v5.11.1.tar.gz"
  sha256 "65206141b81bf151f1dfcceabf280b7b7ced995da3da170b85ce3cbb5f514cc8"
  license all_of: [
    "MIT",
    "BSD-2-Clause-Views", # include/common/f77blas.h
    "BSD-3-Clause",       # include/common/lapacke*
  ]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "85cb969d6a4332302ad2615b8227c150bebe6ccd1b2f66a298a1a7d33cee6112"
    sha256 cellar: :any,                 arm64_sonoma:  "253bb8c870d2813eee0efa5620c19a796049dea51e0c220022eee10c21783d77"
    sha256 cellar: :any,                 arm64_ventura: "5b8e902646ce00d756902935c54dd1ee4e08ed37c3608ebe455137fb0ba65d47"
    sha256 cellar: :any,                 sonoma:        "9eceeaa71fe6a524c913639f5cbfceecc6e2990169320c09b6e60072ce261a03"
    sha256 cellar: :any,                 ventura:       "0016ac73940ca63a4e6d9e55ca84612f8e218968607f60f49eef2d4a301744be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec461a450e6a9916b69ebb9421587e70fd3461fb3b8505311bd52a792ab2d446"
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
