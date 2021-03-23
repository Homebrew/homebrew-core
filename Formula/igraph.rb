class Igraph < Formula
  desc "Network analysis package"
  homepage "https://igraph.org/"
  url "https://github.com/igraph/igraph/releases/download/0.9.1/igraph-0.9.1.tar.gz"
  sha256 "1902810650e8f9d98feefa3eca735db5a879416d00a08f68aad2ca07964cee9f"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6ae842ab97a92237987c202eb561dc309571af3d9452570d8c47edc0f4474b5f"
    sha256 cellar: :any_skip_relocation, big_sur:       "b9d9cbcfc223d72bc33add33264d8bf6f4eb677107f1e72984114f083336fe59"
    sha256 cellar: :any_skip_relocation, catalina:      "c02bb0b1563dfcc3e5511be93d1d20d0f38a34a588919112299b0be4780dd8f6"
    sha256 cellar: :any_skip_relocation, mojave:        "990acbc314d5fec00ccc08bf76f3b436ac297abf3c5c303364315f41961d0aba"
  end

  depends_on "cmake" => :build
  depends_on "arpack"
  depends_on "glpk"
  depends_on "openblas"

  def install
    mkdir "build" do
      # explanation of extra options:
      # * we want a shared library, not a static one
      # * link-time optimization should be enabled if the compiler supports it
      # * thread-local storage of global variables is enabled
      # * GLPK is used as an external dependency
      # * GraphML support should be compiled in (needs libxml2)
      # * use external BLAS and LAPACK from OpenBLAS
      # * use external ARPACK (also from Homebrew)
      # * use vendored CXSparse (the entire SuiteSparse is too big
      #   a dependency and igraph does not need most of it)
      # * use external GLPK (also from Homebrew)
      # * use vendored mini-GMP (external GMP has no additional benefits and it
      #   is heavyweight)
      system "cmake", "-G", "Unix Makefiles",
                      "-DBUILD_SHARED_LIBS=ON",
                      "-DIGRAPH_ENABLE_LTO=AUTO",
                      "-DIGRAPH_ENABLE_TLS=ON",
                      "-DIGRAPH_GLPK_SUPPORT=ON",
                      "-DIGRAPH_GRAPHML_SUPPORT=ON",
                      "-DIGRAPH_USE_INTERNAL_ARPACK=OFF",
                      "-DIGRAPH_USE_INTERNAL_BLAS=OFF",
                      "-DIGRAPH_USE_INTERNAL_CXSPARSE=ON",
                      "-DIGRAPH_USE_INTERNAL_GLPK=OFF",
                      "-DIGRAPH_USE_INTERNAL_GMP=ON",
                      "-DIGRAPH_USE_INTERNAL_LAPACK=OFF",
                      "-DBLA_VENDOR=OpenBLAS",
                      "..", *std_cmake_args
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
