class Igraph < Formula
  desc "Network analysis package"
  homepage "https://igraph.org/"
  url "https://github.com/igraph/igraph/releases/download/1.0.1/igraph-1.0.1.tar.gz"
  sha256 "969f2d7d22f67e788d8638c9a8c96615f50d7819c08978b3ef4a787bb6daa96c"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b3805393001183d91ec1b827c3e8b0f7f1d891f3d212e06f96c04acba8f77e6f"
    sha256 cellar: :any,                 arm64_sequoia: "3290ea536022e5aafdbe0a1e857bfa90cf47e74d10020b30d49200802714d148"
    sha256 cellar: :any,                 arm64_sonoma:  "6346c4806faaeae0893e2ccdaac839e8afefc174c980317f2cd1b5b6c87dfea2"
    sha256 cellar: :any,                 sonoma:        "d8edfe86b7564c1c2967631625918a878d905ddd69957ff7c4887ab6b2f9d0d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ceb3ff22b939cc3a1c9e56fd1ce861bb29ae0cf250f12a155078e44b34dfc23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd9b468b1f12e84c1b9c6a3b424ec783ebf87b363c46b30ddb076e967e8d6ffa"
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
