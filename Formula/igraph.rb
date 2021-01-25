class Igraph < Formula
  desc "Network analysis package"
  homepage "https://igraph.org/"
  url "https://github.com/igraph/igraph/releases/download/0.8.5/igraph-0.8.5.tar.gz"
  sha256 "2e5da63a2b8e9bb497893a17cf77c691df1739c298664f8adb1310a01218f95b"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    cellar :any
    sha256 "df32f814a2a0ab2a4385709941e986fd397f49314845d2f46a0a738eb1ff074e" => :big_sur
    sha256 "c47315766863332a294eb63c135d674142f66faf6176b28f35c0572be3237bcc" => :arm64_big_sur
    sha256 "fd1f5b91421abd8f0daffeb8f6f5399add7703a574eae94d001b6692a717faf8" => :catalina
    sha256 "a1b5b395940614336af1155290e4eed9f964e58138ed9e515950d64d9d34ef3c" => :mojave
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
                          "--with-external-glpk",
                          "--enable-tls"
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
