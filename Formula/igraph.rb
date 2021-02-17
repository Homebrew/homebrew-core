class Igraph < Formula
  desc "Network analysis package"
  homepage "https://igraph.org/"
  url "https://github.com/igraph/igraph/releases/download/0.9.0/igraph-0.9.0.tar.gz"
  sha256 "012e5d5a50420420588c33ec114c6b3000ccde544db3f25c282c1931c462ad7a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d9b4b79ede67853df488dc2fb2fe813035eff927a301a7b74d3ec76800a7e436"
    sha256 cellar: :any_skip_relocation, big_sur:       "3e1078d3f10bdafee36b61d69c5af9d62db1b967ea59bf36ec4eeb2b014f48af"
    sha256 cellar: :any_skip_relocation, catalina:      "8dc7914759c40567d1e70af9b52de41994873cae21a5e33302790e8e8f6543fb"
    sha256 cellar: :any_skip_relocation, mojave:        "356ed288fb210fffdef90bfb55ec379cb33cd4322e74d5268fabcd9d0b945b6f"
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
                   "-ligraph", "-lm", "-o", "test"
    assert_match "Diameter = 9", shell_output("./test")
  end
end
