class Igraph < Formula
  desc "Network analysis package"
  homepage "https://igraph.org/"
  url "https://github.com/igraph/igraph/releases/download/0.9.0/igraph-0.9.0.tar.gz"
  sha256 "012e5d5a50420420588c33ec114c6b3000ccde544db3f25c282c1931c462ad7a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "c47315766863332a294eb63c135d674142f66faf6176b28f35c0572be3237bcc"
    sha256 cellar: :any, big_sur:       "df32f814a2a0ab2a4385709941e986fd397f49314845d2f46a0a738eb1ff074e"
    sha256 cellar: :any, catalina:      "fd1f5b91421abd8f0daffeb8f6f5399add7703a574eae94d001b6692a717faf8"
    sha256 cellar: :any, mojave:        "a1b5b395940614336af1155290e4eed9f964e58138ed9e515950d64d9d34ef3c"
  end

  depends_on "cmake" => :build
  depends_on "glpk"
  depends_on "gmp"

  on_linux do
    depends_on "openblas"
  end

  def install
    mkdir "build" do
      system "cmake", "-G", "Unix Makefiles", "-DIGRAPH_ENABLE_TLS=ON", "..", *std_cmake_args
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
        igraph_diameter(&graph, &diameter, 0, 0, 0, IGRAPH_UNDIRECTED, 1);
        printf("Diameter = %f\\n", (double) diameter);
        igraph_destroy(&graph);
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}/igraph", "-L#{lib}",
                   "-ligraph", "-o", "test"
    assert_match "Diameter = 9", shell_output("./test")
  end
end
