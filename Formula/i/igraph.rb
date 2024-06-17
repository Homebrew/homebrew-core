class Igraph < Formula
  desc "Network analysis package"
  homepage "https://igraph.org/"
  url "https://github.com/igraph/igraph/releases/download/0.10.12/igraph-0.10.12.tar.gz"
  sha256 "b011f7f9f38a3e59924cc9ff652e6d33105fa03fcaf3792f47d752626a0a4625"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fa8b041b992e92e717c0bb631d93085625f8907c72a02ad939575b4cfdbf01db"
    sha256 cellar: :any,                 arm64_ventura:  "582819ba81700839022b59b40323300a23fcf46272b5e0317d1342f22912e4b7"
    sha256 cellar: :any,                 arm64_monterey: "75492919033cd99d118cf62cd31549323954410da025d0282275656a22800ade"
    sha256 cellar: :any,                 sonoma:         "5e5ff27f272e0b5ade1918db44996330c83d8738f794974e7d436f20d9344142"
    sha256 cellar: :any,                 ventura:        "872794d0968c5042027dfaea4d5d8744a4b4611d14301fe75594cd309d9025d9"
    sha256 cellar: :any,                 monterey:       "584b29177fa0091000a3b9239a73a39bb79e409e92abd5b215b1aea18ab9c23d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12a7093ff375236d27ccdf9694a0162e809b093ed8a586decf8fd807badc9e86"
  end

  depends_on "cmake" => :build
  depends_on "arpack"
  depends_on "glpk"
  depends_on "gmp"
  depends_on "openblas"

  uses_from_macos "libxml2"

  def install
    mkdir "build" do
      # explanation of extra options:
      # * we want a shared library, not a static one
      # * link-time optimization should be enabled if the compiler supports it
      # * thread-local storage of global variables is enabled
      # * force the usage of external dependencies from Homebrew where possible
      # * GraphML support should be compiled in (needs libxml2)
      # * BLAS and LAPACK should come from OpenBLAS
      # * prevent the usage of ccache even if it is installed to ensure that we
      #    have a clean build
      system "cmake", "-G", "Unix Makefiles",
                      "-DBUILD_SHARED_LIBS=ON",
                      "-DIGRAPH_ENABLE_LTO=AUTO",
                      "-DIGRAPH_ENABLE_TLS=ON",
                      "-DIGRAPH_GLPK_SUPPORT=ON",
                      "-DIGRAPH_GRAPHML_SUPPORT=ON",
                      "-DIGRAPH_USE_INTERNAL_ARPACK=OFF",
                      "-DIGRAPH_USE_INTERNAL_BLAS=OFF",
                      "-DIGRAPH_USE_INTERNAL_GLPK=OFF",
                      "-DIGRAPH_USE_INTERNAL_GMP=OFF",
                      "-DIGRAPH_USE_INTERNAL_LAPACK=OFF",
                      "-DBLA_VENDOR=OpenBLAS",
                      "-DUSE_CCACHE=OFF",
                      "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <igraph.h>
      int main(void) {
        igraph_real_t diameter;
        igraph_t graph;
        igraph_rng_seed(igraph_rng_default(), 42);
        igraph_erdos_renyi_game(&graph, IGRAPH_ERDOS_RENYI_GNP, 1000, 5.0/1000, IGRAPH_UNDIRECTED, IGRAPH_NO_LOOPS);
        igraph_diameter(&graph, &diameter, 0, 0, 0, 0, IGRAPH_UNDIRECTED, 1);
        printf("Diameter = %f\\n", (double) diameter);
        igraph_destroy(&graph);
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}/igraph", "-L#{lib}",
                   "-ligraph", "-lm", "-o", "test"
    assert_match "Diameter = 8", shell_output("./test")
  end
end
