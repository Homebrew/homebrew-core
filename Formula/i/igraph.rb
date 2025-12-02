class Igraph < Formula
  desc "Network analysis package"
  homepage "https://igraph.org/"
  url "https://github.com/igraph/igraph/releases/download/1.0.0/igraph-1.0.0.tar.gz"
  sha256 "91e23e080634393dec4dfb02c2ae53ac4e3837172bb9047d32e39380b16c0bb0"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fe00edb994e146b0cbec52620726016f7f0cfc9c30e24e34ebfd057770cbf20d"
    sha256 cellar: :any,                 arm64_sequoia: "0c97c91e503b6f70db933d5bfafbc2cce75ebea5f22fa71cc119a537b18d4eec"
    sha256 cellar: :any,                 arm64_sonoma:  "651b32c9be6f0e65008fc25a8023aa6a8b9518e7f115f5403e69b4162203d3ce"
    sha256 cellar: :any,                 sonoma:        "acfc0a3257fbaade1e7d6353ca2c5519ea439c0d7ae7096b026f54f04639d918"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9459bd61fc47cbe5d04ee52e3e45a46ec6f8a57be6107884d0edefb43e3e9c91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7609c6d569ec5d74fc5d065201756f3209e9368421065ad77e179edadfe6f988"
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
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DIGRAPH_ENABLE_LTO=AUTO
      -DIGRAPH_ENABLE_TLS=ON
      -DIGRAPH_GLPK_SUPPORT=ON
      -DIGRAPH_GRAPHML_SUPPORT=ON
      -DIGRAPH_USE_INTERNAL_ARPACK=OFF
      -DIGRAPH_USE_INTERNAL_BLAS=OFF
      -DIGRAPH_USE_INTERNAL_GLPK=OFF
      -DIGRAPH_USE_INTERNAL_GMP=OFF
      -DIGRAPH_USE_INTERNAL_LAPACK=OFF
      -DBLA_VENDOR=OpenBLAS
      -DUSE_CCACHE=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <igraph.h>
      int main(void) {
          igraph_real_t diameter;
          igraph_t graph;
          igraph_setup();
          igraph_rng_seed(igraph_rng_default(), 42);
          igraph_erdos_renyi_game_gnp(&graph, 1000, 5.0/1000, IGRAPH_UNDIRECTED, IGRAPH_SIMPLE_SW, IGRAPH_EDGE_UNLABELED);
          igraph_diameter(&graph, NULL, &diameter, NULL, NULL, NULL, NULL, IGRAPH_UNDIRECTED, /*unconn=*/ true);
          printf("Diameter = %g\\n", (double) diameter);
          igraph_destroy(&graph);
          return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}/igraph", "-L#{lib}",
                   "-ligraph", "-lm", "-o", "test"
    assert_match "Diameter = 8", shell_output("./test")
  end
end
