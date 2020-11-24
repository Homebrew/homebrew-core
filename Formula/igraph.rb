class Igraph < Formula
  desc "Network analysis package"
  homepage "https://igraph.org/"
  url "https://github.com/igraph/igraph/releases/download/0.8.4/igraph-0.8.4.tar.gz"
  sha256 "ceef4e169777bdfb94673a068d128e189c311d6de62fe88569bbae090836f888"
  license "GPL-2.0-or-later"

  bottle do
    cellar :any
    sha256 "7de12858707f5b25dc44207ab51b4cf55f9079a906cac10133847ac1542411a9" => :big_sur
    sha256 "6e7d352c5b144dddc9b05052c953bc21a6dcec380d1afcf6f1b3d80d8b22f257" => :catalina
    sha256 "d60d6d7ba09921385e29b02ca5d26fd0b7c15d1bd6b3de7e9cea33f533c76fd1" => :mojave
    sha256 "c8081231567eb1fdbe966e687b9ac759ecbd0c61f39a26e316d7c34e29e7c365" => :high_sierra
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
