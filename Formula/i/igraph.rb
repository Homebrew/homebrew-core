class Igraph < Formula
  desc "Network analysis package"
  homepage "https://igraph.org/"
  url "https://github.com/igraph/igraph/releases/download/0.10.16/igraph-0.10.16.tar.gz"
  sha256 "15a1540a8d270232c9aa99adeeffb7787bea96289d6bef6646ec9c91a9a93992"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ab9d25f69f94b16f9283e076f20a36b370668120a7b57e6ea53b5f26541cb8dd"
    sha256 cellar: :any,                 arm64_sonoma:  "109a713e6f1d4176e826b15f5a651bc919f1c2bae67198d7cea641da7f327cfc"
    sha256 cellar: :any,                 arm64_ventura: "357ba0bc0f907994dec39505c8fbba6882b9f8dbaaefa5f4efcb8a722ff956c3"
    sha256 cellar: :any,                 sonoma:        "3a8a7391bc2dd456019e2072e738b8a5dff3715901d5987869eb42edda9ca818"
    sha256 cellar: :any,                 ventura:       "77a3630e6f4f1140f7dac71f33e7031dd3dc15ce7694428b27e68f001d49329d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8732c9994495bcd776ec0b025bc8fabe9b6888b51493a0f5961c16f0d095751b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f09d1813d10e9fb4e2a8216416f1131d85dcf874df721ccbf6ecc06c28d502bb"
  end

  depends_on "cmake" => :build
  depends_on "arpack"
  depends_on "glpk"
  depends_on "gmp"
  depends_on "openblas"

  uses_from_macos "libxml2"

  def install
    # explanation of extra options:
    # * we want a shared library, not a static one
    # * link-time optimization should be enabled if the compiler supports it
    # * thread-local storage of global variables is enabled
    # * force the usage of external dependencies from Homebrew where possible
    # * GraphML support should be compiled in (needs libxml2)
    # * BLAS and LAPACK should come from OpenBLAS
    # * prevent the usage of ccache even if it is installed to ensure that we
    #    have a clean build
    system "cmake", "-S", ".", "-B", "build",
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
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-I#{include}/igraph", "-L#{lib}",
                   "-ligraph", "-lm", "-o", "test"
    assert_match "Diameter = 8", shell_output("./test")
  end
end
