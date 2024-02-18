class Igraph < Formula
  desc "Network analysis package"
  homepage "https://igraph.org/"
  url "https://github.com/igraph/igraph/releases/download/0.10.10/igraph-0.10.10.tar.gz"
  sha256 "6148f2e72a183ef5cd08324cccc73fa9eb8e54bb5a96c7f8f3c0465432ec2404"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "87783cdfe464e19d22a2df1fa03cfcadd270e69b243e2b02ac120bf5a1e29bc8"
    sha256 cellar: :any,                 arm64_ventura:  "229f046b0c95a6c93b1e1e4bcfb36accfb88bd1f7601a327d8736b54c2dabbe0"
    sha256 cellar: :any,                 arm64_monterey: "f7d277f51ca65c6d5ef40c41c8340db176ee01e63190516ede5aae3b34e953ea"
    sha256 cellar: :any,                 sonoma:         "d567436b831b15bf468da55551adb861eeb8be3d948e9ba31e72f70d92ebd61f"
    sha256 cellar: :any,                 ventura:        "0751f60dfa16b52137d37358379dd9322aacc36d376d0d5440a320caab665d7b"
    sha256 cellar: :any,                 monterey:       "cfb479057b1363823bbf5fbe97602c96ba5c237fe50c2344fb744779bce95f8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cde5ed247dc45961d45f505c8760d5472c9615c38925c2be4551e0c1210367a5"
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
