class Igraph < Formula
  desc "Network analysis package"
  homepage "https://igraph.org/"
  url "https://github.com/igraph/igraph/releases/download/1.0.0/igraph-1.0.0.tar.gz"
  sha256 "91e23e080634393dec4dfb02c2ae53ac4e3837172bb9047d32e39380b16c0bb0"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2bbee1fb97caa1f10aa7744ff1bc2e817099c60b1219efc397d7aef64bfd3263"
    sha256 cellar: :any,                 arm64_sequoia: "97fd516356e753b74e2b43f8ce7f5f36b3a05f10ad7c5faa95f959273167a32a"
    sha256 cellar: :any,                 arm64_sonoma:  "af513ee68a687b06d5568f8b58c426b6fa1a3276926b20e29373365d41137889"
    sha256 cellar: :any,                 sonoma:        "7d9ef0b86e218b330fbe9acf8c760bff2fed0998fd8e57cdf67984ef97c515f9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "55b153c6bbf5cc63d72fa397a1d0cc329fad87f513ccf480f5f7247199bec063"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f61547e0249555f2d75365f26e7431c99d5af822a7564c7051608a6dbc0f3a12"
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
