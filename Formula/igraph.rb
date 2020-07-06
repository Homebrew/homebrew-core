class Igraph < Formula
  desc "Network analysis package"
  homepage "https://igraph.org/"
  url "https://github.com/igraph/igraph/releases/download/0.8.2/igraph-0.8.2.tar.gz"
  sha256 "718a471e7b8cbf02e3e8006153b7be6a22f85bb804283763a0016280e8a60e95"
  license "GPL-2.0"

  bottle do
    cellar :any
    sha256 "3005e637b6cb7cbed28b6dc997d480f8a1917c4118852a107ae0b59936d20698" => :catalina
    sha256 "81181b904e63af33766a9c967f5ae42a11dadc8e72ba80604804636e663414ce" => :mojave
    sha256 "40791d18478711af9cc497917ce7b34af179538bd719108d04be073faec57db9" => :high_sierra
  end

  depends_on "glpk"
  depends_on "gmp"

  on_linux do
    depends_on "openblas"
  end

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
