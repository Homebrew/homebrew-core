class Igraph < Formula
  desc "Network analysis package"
  homepage "https://igraph.org/"
  url "https://github.com/igraph/igraph/releases/download/0.10.7/igraph-0.10.7.tar.gz"
  sha256 "b9e2a46b70896a379d784ea227f076b59750cc7411463b1d4accbf9e38b361ad"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "39e5a3d70fd4520d6afe3fae3950624dcc96fd6117b3755783a550ac9677badb"
    sha256 cellar: :any,                 arm64_ventura:  "49020dadfecfbd851179096fe42425f85c97a683579c95db38aa5292901c5c08"
    sha256 cellar: :any,                 arm64_monterey: "26b016bbdf93559f0f5d00332238bc1f11da04039728183c8eaa7138cbbd4aee"
    sha256 cellar: :any,                 arm64_big_sur:  "2ea5120c3ee598d518ac861d015057aa8076b260ced5799253d2354c561baad3"
    sha256 cellar: :any,                 sonoma:         "b1f824e38e516d586d4357b9bec5f98009b1e69fa2d6c62074ca871c10dd9597"
    sha256 cellar: :any,                 ventura:        "08f3e8bdac296dac446a462551fc8e69c4546d619b0df87957e7ac093a87fc78"
    sha256 cellar: :any,                 monterey:       "dc040a9e757957789671c17fa78351b19fe439f633cfeec555ad0518fb8e90fa"
    sha256 cellar: :any,                 big_sur:        "fc26790b7c8ab086a321d789fe1df52e67a61eecc954072d9c9660eb365cc6cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d1babcd095b75507ebc19635ee6f42ecb2e8c250cd54fe57034de4df96121b5"
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
