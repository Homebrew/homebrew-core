class Igraph < Formula
  desc "Network analysis package"
  homepage "https://igraph.org/"
  url "https://github.com/igraph/igraph/releases/download/0.8.5/igraph-0.8.5.tar.gz"
  sha256 "2e5da63a2b8e9bb497893a17cf77c691df1739c298664f8adb1310a01218f95b"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    cellar :any
    sha256 "f465b8d9fefa756c504d37e0af723557c276b15d1f7d548ed25d45368dded147" => :big_sur
    sha256 "c545569d11877ab3692dff937cd885f6ee58ca492af51839e47c2f0cef8a538d" => :arm64_big_sur
    sha256 "8e9868d06e9ad6a4bc388f7f44ed175fcc54f81c4362eb3de324fadadaf8c3c3" => :catalina
    sha256 "e14e7cb3c9925863daea2981b4130bcdb969a34c6e73b43dcfc49820c809948d" => :mojave
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
