class Libblastrampoline < Formula
  desc "Using PLT trampolines to provide a BLAS and LAPACK demuxing library"
  homepage "https://github.com/JuliaLinearAlgebra/libblastrampoline"
  url "https://github.com/JuliaLinearAlgebra/libblastrampoline/archive/refs/tags/v5.14.0.tar.gz"
  sha256 "1036d8a34d2b6cad715da9b5f84c505517c9c65c24fcf90ba0f17d4d0003811a"
  license all_of: [
    "MIT",
    "BSD-2-Clause-Views", # include/common/f77blas.h
    "BSD-3-Clause",       # include/common/lapacke*
  ]

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "8246c1e2d9ac09019805c91834c8c1721f0523789e625f5ceceb399c9c8f592f"
    sha256 cellar: :any,                 arm64_sequoia: "f6e8e315b5c6eb96d380b886f3abbec62af142371bec18e05d1b0163811bec65"
    sha256 cellar: :any,                 arm64_sonoma:  "00b80856ba5d493784d14d1623bfb62a238a78215bb21387b43ef223aca74311"
    sha256 cellar: :any,                 sonoma:        "5ac2b19824d89120ed9795a916eeda8e1d7d7cb56982e1dca2492a440472accb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6cd17d80c1c8fdde9d0938d682096e07532a3e4a0c15df5a6dffd258112bdf97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "923847ec57d5d5dd767727d163b90a442393b77fea844d31995ca7e220c1f4fd"
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
