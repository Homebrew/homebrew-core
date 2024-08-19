class Igraph < Formula
  desc "Network analysis package"
  homepage "https://igraph.org/"
  url "https://github.com/igraph/igraph/releases/download/0.10.13/igraph-0.10.13.tar.gz"
  sha256 "c6dc44324f61f52c098bedb81f6a602365d39d692d5068ca4fc3734b2a15e64c"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "33dabbdc4d649b0f606686a53021907dab2b308549e6141b30de1f26d4bfcb26"
    sha256 cellar: :any,                 arm64_ventura:  "836088cf17820f44cb4e690d298252823a520ff34f12922635abd67dd76d3368"
    sha256 cellar: :any,                 arm64_monterey: "c526e360e039e6f70c37cc86c2aaab65c2e46e84a27990188b518bfe90a49e40"
    sha256 cellar: :any,                 sonoma:         "079d2ee5b0d12c552789c6817783707c3ce0f93b625b1420ece34327f11258ac"
    sha256 cellar: :any,                 ventura:        "8b08da86dcc4de90a999d02f7aab893a0b67b9e4c784f18cbbb16871009e0edb"
    sha256 cellar: :any,                 monterey:       "9c6833b7a539dd2fcbb4b63b0d9f9ee2f997a2d99bdd435d3e38fdcd9d88204c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1b9dd2184649e619c82bef92b0e42dcca1b8578f1e0ac0c765ef865d3aefc92"
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
