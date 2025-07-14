class Libblastrampoline < Formula
  desc "Using PLT trampolines to provide a BLAS and LAPACK demuxing library"
  homepage "https://github.com/JuliaLinearAlgebra/libblastrampoline"
  url "https://github.com/JuliaLinearAlgebra/libblastrampoline/archive/refs/tags/v5.13.1.tar.gz"
  sha256 "6df0eddd846db56b885056641cf02304862411bd0e641d444acf8f4eb2e33327"
  license all_of: [
    "MIT",
    "BSD-2-Clause-Views", # include/common/f77blas.h
    "BSD-3-Clause",       # include/common/lapacke*
  ]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "03497a53d3183dacd6edf1e39d73fe59947cd136255401fcffe25dce61a7139d"
    sha256 cellar: :any,                 arm64_sonoma:  "10f49ac34d432fa76c15b21a87bf2947fe4ec8d24cf9f4acbef1673a4d4fa967"
    sha256 cellar: :any,                 arm64_ventura: "8a622b45cbe58c6d30bc9fdcb5d501d05b96893351982837fa9b587cb3892597"
    sha256 cellar: :any,                 sonoma:        "fe04097067b8f9839216a297cc3cacec98acce820c1a816e4fc9d79ce36bf212"
    sha256 cellar: :any,                 ventura:       "0ae48fe3914b9b2ffc998a360d40b9bdd7fe40f40408be4cf27250fdb8e319c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a443a4792ca5ac36b046b8235e0f0dcf2967097ff404302894cb489850fd0f6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ae117c4ef95be2554f313e0bbeeea3e02a4c1f3793051afe8a0a5a457114886"
  end

  depends_on "openblas" => :test

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
