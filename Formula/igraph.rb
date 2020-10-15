class Igraph < Formula
  desc "Network analysis package"
  homepage "https://igraph.org/"
  url "https://github.com/igraph/igraph/releases/download/0.8.3/igraph-0.8.3.tar.gz"
  sha256 "cc935826d3725a9d95f1b0cc46e3c08c554b29cdd6943f0286d965898120b3f1"
  license "GPL-2.0-or-later"

  bottle do
    cellar :any
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
