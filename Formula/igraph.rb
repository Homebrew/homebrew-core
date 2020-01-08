class Igraph < Formula
  desc "Network analysis package"
  homepage "https://igraph.org/"
  url "https://igraph.org/nightly/get/c/igraph-0.7.1.tar.gz"
  sha256 "d978030e27369bf698f3816ab70aa9141e9baf81c56cc4f55efbe5489b46b0df"
  revision 6

  bottle do
    cellar :any
    sha256 "953fd2e72c9694d1d6d166cefc363abe25f1f83cae80e8eed9dd2255e542a667" => :catalina
    sha256 "ba26e3fef6083917021816a4536bada4f29b95bcd4099a23beee7cac176aa600" => :mojave
    sha256 "f660cb85c0fc5ad020fca593b311c50078e1345fe85bc2cb5292646d1d0d6fa5" => :high_sierra
    sha256 "63d5ac34c831bfb3bdcdc89a408a6ad004198fb784a50facb3f898a567f7b9b1" => :sierra
    sha256 "8718c7a6cd3ffed8ee706f6991f2791c6d02f663db93beadd56e592c3edf544d" => :el_capitan
    sha256 "bf929af83b33d8a00fc52b72fcae9fa0636fcc506ee0cbf2bf7ab267d9ee14d2" => :yosemite
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
