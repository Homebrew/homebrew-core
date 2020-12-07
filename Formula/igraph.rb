class Igraph < Formula
  desc "Network analysis package"
  homepage "https://igraph.org/"
  url "https://github.com/igraph/igraph/releases/download/0.8.5/igraph-0.8.5.tar.gz"
  sha256 "2e5da63a2b8e9bb497893a17cf77c691df1739c298664f8adb1310a01218f95b"
  license "GPL-2.0-or-later"

  bottle do
    cellar :any
    sha256 "e0774e57111e6ed39f5466fa4bde50008b8f4b3ceace230f0aae584c3ede5253" => :big_sur
    sha256 "e3d73e86506b8d585f5f268aea9b0121a8ae97e7ae13fc5c90dfab55406e88c2" => :catalina
    sha256 "e824a9813f0acda90333cff67114bad36bf7e0723c6a96dc673729e7dfbb7382" => :mojave
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
