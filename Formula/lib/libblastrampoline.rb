class Libblastrampoline < Formula
  desc "Using PLT trampolines to provide a BLAS and LAPACK demuxing library"
  homepage "https://github.com/JuliaLinearAlgebra/libblastrampoline"
  url "https://github.com/JuliaLinearAlgebra/libblastrampoline/archive/refs/tags/v5.15.0.tar.gz"
  sha256 "69e0be57ebf037c1997c35edf03565614cd3c6863a695d01348a21bf1f482e74"
  license all_of: [
    "MIT",
    "BSD-2-Clause-Views", # include/common/f77blas.h
    "BSD-3-Clause",       # include/common/lapacke*
  ]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "438c7cc5a4b1c5272a7daccb970d49d1e85336e12c0c04861e0ed41fd81f9628"
    sha256 cellar: :any,                 arm64_sequoia: "16a9fc5256cb99de39f67c06400489615b3545c15c20c20618e0e35de21f544b"
    sha256 cellar: :any,                 arm64_sonoma:  "6b26660fb5231a8e624e159ee93dce94bba7ddeacfc4393498e7cdce2b49190d"
    sha256 cellar: :any,                 sonoma:        "ef556a70b35c24ddfbac6c3ff5bb5d7dc9ee0d655724f8747d99de4b75b1cb58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e030ff06d4bcdc58f44883a75949da9087a9eb031bd395a0c176686a3f07efd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b5587f9b1d19d6bcd93cc3520ef040288b9ee5ef8558f6efae1da054aae0eb8"
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

    test_libs = [shared_library("libopenblas64_")]
    if OS.mac?
      test_libs << "/System/Library/Frameworks/Accelerate.framework/Accelerate"
      ENV["DYLD_LIBRARY_PATH"] = Formula["openblas64"].opt_lib.to_s
    else
      ENV["LD_LIBRARY_PATH"] = Formula["openblas64"].opt_lib.to_s
    end

    test_libs.each do |test_lib|
      with_env(LBT_DEFAULT_LIBS: test_lib) do
        assert_equal test_lib, shell_output("./api_test")
        system "./dgemm_test"
      end
    end
  end
end
