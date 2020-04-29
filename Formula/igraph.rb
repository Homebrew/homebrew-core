class Igraph < Formula
  desc "Network analysis package"
  homepage "https://igraph.org/"
  url "https://github.com/igraph/igraph/releases/download/0.8.2/igraph-0.8.2.tar.gz"
  sha256 "718a471e7b8cbf02e3e8006153b7be6a22f85bb804283763a0016280e8a60e95"

  bottle do
    cellar :any
    sha256 "e0ff16ce74b2fb424db6ca1bb1974bfe047143dea608687433172b989671ac7f" => :catalina
    sha256 "ddccb3cfc32f42d88ef243d0eea3bfd5254e60e427cabb45675551fd934cf3f9" => :mojave
    sha256 "31fa14d8819baacf7be455cecc5f233f618f856e2fc2bc3ef924d1ce248e4f33" => :high_sierra
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
