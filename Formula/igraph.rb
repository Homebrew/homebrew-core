class Igraph < Formula
  desc "Network analysis package"
  homepage "https://igraph.org/"
  url "https://github.com/igraph/igraph/releases/download/0.9.0/igraph-0.9.0.tar.gz"
  sha256 "012e5d5a50420420588c33ec114c6b3000ccde544db3f25c282c1931c462ad7a"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6ae842ab97a92237987c202eb561dc309571af3d9452570d8c47edc0f4474b5f"
    sha256 cellar: :any_skip_relocation, big_sur:       "b9d9cbcfc223d72bc33add33264d8bf6f4eb677107f1e72984114f083336fe59"
    sha256 cellar: :any_skip_relocation, catalina:      "c02bb0b1563dfcc3e5511be93d1d20d0f38a34a588919112299b0be4780dd8f6"
    sha256 cellar: :any_skip_relocation, mojave:        "990acbc314d5fec00ccc08bf76f3b436ac297abf3c5c303364315f41961d0aba"
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
