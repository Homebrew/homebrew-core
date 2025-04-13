class Igraph < Formula
  desc "Network analysis package"
  homepage "https://igraph.org/"
  url "https://github.com/igraph/igraph/releases/download/0.10.15/igraph-0.10.15.tar.gz"
  sha256 "03ba01db0544c4e32e51ab66f2356a034394533f61b4e14d769b9bbf5ad5e52c"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "05e858933d67bf168bb125e3cb2e6037bbeb28197f9a22a998d513ce1bf7289c"
    sha256 cellar: :any,                 arm64_sonoma:  "79aecc04dda8059ec114e1562dd5ac4e1051b22c9bc2ed53f44b11fccc69af4d"
    sha256 cellar: :any,                 arm64_ventura: "405a45f59e91eb93a06222d9b3bb4d6dbddea521acb0c302362fb8507d91055c"
    sha256 cellar: :any,                 sonoma:        "aed39268ccb1453bfb2bdc91bd6324cb84cb97a5d8510f63f1a8969579594d0f"
    sha256 cellar: :any,                 ventura:       "a5d07f29fc614f21980859db3f9b3557972033c7f2a64284253f7213abf5d4f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3156331b8e0752a21a710c5c64b8e0894dadc6d80083e56409f39195879a05a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc2fe384bb82430e1a4671ba9ff56d2a2579250e3b2ab3748b49eb6a2b654635"
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
