class Igraph < Formula
  desc "Network analysis package"
  homepage "https://igraph.org/"
  url "https://github.com/igraph/igraph/releases/download/0.10.6/igraph-0.10.6.tar.gz"
  sha256 "99bf91ee90febeeb9a201f3e0c1d323c09214f0b5f37a4290dc3b63f52839d6d"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e10244de3673bf2fde324005b37476540892c6e68f30355fef88ed13b555a697"
    sha256 cellar: :any,                 arm64_monterey: "f24c299005b9e663e2e14de8461b4dbe143bc3e08bc4c09357037effe9c56796"
    sha256 cellar: :any,                 arm64_big_sur:  "3d02b491006491e7772ef025ddd931bd863af41c5866c4eea375998d912bfc9f"
    sha256 cellar: :any,                 ventura:        "ccf938c082f023eb1b8944ef83719ef12a2b453420d7193a05063dc40ff5bbe5"
    sha256 cellar: :any,                 monterey:       "3b4ab17615d83c15bbc977c27854826b22c87f4cdf8b4eb8861eff39de7fc95a"
    sha256 cellar: :any,                 big_sur:        "bcfd5323ae2dc53658f5c62d23c686c69df8d52dfff93c2bd1d8262d833f5785"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f13c975e2f6b2a76e908eaa0c91aaf1cbaf975d73d8a8f3d02cd9f7af4e955f6"
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
