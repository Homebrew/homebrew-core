class Igraph < Formula
  desc "Network analysis package"
  homepage "https://igraph.org/"
  url "https://github.com/igraph/igraph/releases/download/0.10.4/igraph-0.10.4.tar.gz"
  sha256 "aa5700b58c5f1e1de1f4637ab14df15c6b20e25e51d0f5a260921818e8f02afc"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "924cf6d732723f7c624e306aca84ca49b47b7a91a56edfcf7c4e1155490d9ec6"
    sha256 cellar: :any,                 arm64_monterey: "d9860b5fa36ff4c63d91223535b2c1a86580dfc9683d81fbd6633adf93ac5c4b"
    sha256 cellar: :any,                 arm64_big_sur:  "8f692932c28ac91985b3150ec7ed735c9b0748eba3796deeee83293a983b6a62"
    sha256 cellar: :any,                 ventura:        "4c7aeea854bdd88082de24dd37f1ffb591f36f1cbe50bec0ca46d85635a8bf40"
    sha256 cellar: :any,                 monterey:       "dee010f3c9cfbd3fe9f3ea53267be71c57e25bbf96213903e408d0c6c4a75058"
    sha256 cellar: :any,                 big_sur:        "f373c0447546203bccf316ec435e111ecad273c4e4b9574c84db242ddb778800"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0812cf1e53956d61f4070917ad509096a2ab61e3e0f5a355edef47203547229c"
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
