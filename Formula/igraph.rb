class Igraph < Formula
  desc "Network analysis package"
  homepage "https://igraph.org/"
  url "https://github.com/igraph/igraph/releases/download/0.8.1/igraph-0.8.1.tar.gz"
  sha256 "266e1bf9e81305b368fbaa2218a8416c51ae85ea164e3657c574dc3898ca7b71"

  bottle do
    cellar :any
    sha256 "5d618ed756944bd280ae27236aaa5f428e2b6f676cab1f9f71675c89273be18d" => :catalina
    sha256 "84d4d17b1345904c0ec6048d98eea4b26d510e7e4bb69ac5e30ece8ee11caf14" => :mojave
    sha256 "9d205ed06f1f601ca9aa5138ce8f8f8aa62f723488d87aa536a433b51c6bf0d0" => :high_sierra
  end

  depends_on "glpk"
  depends_on "gmp"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-external-blas",
                          "--with-external-lapack",
                          "--with-external-glpk"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <igraph.h>
      int main(void) {
        igraph_integer_t diameter;
        igraph_t graph;
        igraph_rng_seed(igraph_rng_default(), 42);
        igraph_erdos_renyi_game(&graph, IGRAPH_ERDOS_RENYI_GNP, 1000, 5.0/1000, IGRAPH_UNDIRECTED, IGRAPH_NO_LOOPS);
        igraph_diameter(&graph, &diameter, 0, 0, 0, IGRAPH_UNDIRECTED, 1);
        printf("Diameter = %d\\n", (int) diameter);
        igraph_destroy(&graph);
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}/igraph", "-L#{lib}",
                   "-ligraph", "-o", "test"
    assert_match "Diameter = 9", shell_output("./test")
  end
end
