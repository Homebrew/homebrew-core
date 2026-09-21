class Libblastrampoline < Formula
  desc "Using PLT trampolines to provide a BLAS and LAPACK demuxing library"
  homepage "https://github.com/JuliaLinearAlgebra/libblastrampoline"
  url "https://github.com/JuliaLinearAlgebra/libblastrampoline/archive/refs/tags/v5.16.0.tar.gz"
  sha256 "0067b9a0044011ba0a443c9d7677c574d2bfd419fc27dc080b33005cce2ab92d"
  license all_of: [
    "MIT",
    "BSD-2-Clause-Views", # include/common/f77blas.h
    "BSD-3-Clause",       # include/common/lapacke*
  ]

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "59cbab5b3da6915ee96a4679b2c967609d042509774b610b4aca260460e6dc43"
    sha256 cellar: :any, arm64_tahoe:       "be4220763373b3e66590e14be7b5481e997bbe8bd54156571210e4f9636126cc"
    sha256 cellar: :any, arm64_sequoia:     "d402d97b4d342aa444e39bed5e19193659d3120779e6209f3be42294c75c108a"
    sha256 cellar: :any, arm64_linux:       "52a0072fd9d4b6b84248585dae972baab7dbaddcd39b3b727394a8d05702db14"
    sha256 cellar: :any, x86_64_linux:      "bd488926e5bf9867a561ca837d22e2373fd106bf049c6dddffc1803828166157"
  end

  depends_on "openblas64" => :test

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

    # Full path as `shell_output` runs via SIP-protected `/bin/sh` which strips `DYLD_*`
    test_libs = [(formula_opt_lib("openblas64")/shared_library("libopenblas64_")).to_s]
    test_libs << "/System/Library/Frameworks/Accelerate.framework/Accelerate" if OS.mac?

    test_libs.each do |test_lib|
      with_env(LBT_DEFAULT_LIBS: test_lib) do
        assert_equal test_lib, shell_output("./api_test")
        system "./dgemm_test"
      end
    end
  end
end
