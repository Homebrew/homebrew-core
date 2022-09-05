class Igraph < Formula
  desc "Network analysis package"
  homepage "https://igraph.org/"
  url "https://github.com/igraph/igraph/releases/download/0.10.0/igraph-0.10.0.tar.gz"
  sha256 "62e3c9e51ac5b0f1871142aac23956f3a6a337fee980bf5474bd4ac3d76e1a68"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3f2c3a43db1af180e856531b027ad8f22734110500120d06e59a56ddbee8e7d8"
    sha256 cellar: :any,                 arm64_big_sur:  "21c1648f672438f1cd3c22e980988a647a589232eb0916233c14b4610017adc7"
    sha256 cellar: :any,                 monterey:       "1a39ce4e74b946de0a621138e83c2141d67edf5f27545f1bc2289ffbb6052080"
    sha256 cellar: :any,                 big_sur:        "6bc9e5625114c1b6359861bc366e10b60d4c60cd7cd81b14589068cd29d1da1c"
    sha256 cellar: :any,                 catalina:       "47aa257cdddf3ebae1df8b48aede19003540fc55ae9811a574adfa5b19c7f27a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a508255694a5e7f25341a8232d47583316b86754d643a323e77374a5d3c8cee"
  end

  depends_on "cmake" => :build
  depends_on "arpack"
  depends_on "glpk"
  depends_on "gmp"
  depends_on "openblas"
  depends_on "suite-sparse"

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
                      "-DIGRAPH_USE_INTERNAL_CXSPARSE=OFF",
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
        igraph_diameter(&graph, &diameter, 0, 0, 0, IGRAPH_UNDIRECTED, 1);
        printf("Diameter = %f\\n", (double) diameter);
        igraph_destroy(&graph);
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}/igraph", "-L#{lib}",
                   "-ligraph", "-lm", "-o", "test"
    assert_match "Diameter = 9", shell_output("./test")
  end
end
