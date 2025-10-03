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
    sha256 cellar: :any,                 arm64_tahoe:   "02529f6d1e6a9e96282b010920aa60584677c57fc169e0843947ad8fb1a68a59"
    sha256 cellar: :any,                 arm64_sequoia: "321796555ea966414963f103e363b2763f50f8bc7cd3af5a427e9b7c5019b7f4"
    sha256 cellar: :any,                 arm64_sonoma:  "2b2ca33deeb68457c7a163db9f38e6aa2ba0c63f641968d63579aaaf26c69825"
    sha256 cellar: :any,                 arm64_ventura: "5131ca461fc9483dc2c058333998ba84b3d82bddb6b649164cff08cdd88cd5f5"
    sha256 cellar: :any,                 sonoma:        "1da55896bc950f7bbc231519bffb881d00c284e362f4647ab15f59cb4baf35df"
    sha256 cellar: :any,                 ventura:       "26c531ad1c3ae73049dc270da5c73e7652e34f1a8acdc63fb76066630174498f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a29f69f1580759dec7d3001b335b89b12602579ee156c3f28e73693ddc897f4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e90636c4edc3ae00b4dceca5182d409ab08d7327cac94274635fbcd454c4745c"
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
