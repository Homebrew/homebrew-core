class Igraph < Formula
  desc "Network analysis package"
  homepage "https://igraph.org/"
  url "https://github.com/igraph/igraph/releases/download/0.10.2/igraph-0.10.2.tar.gz"
  sha256 "2c2b9f18fc2f84b327f1146466942eb3e3d2ff09b6738504efb9e5edf2728c83"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "91aa21f36ccaee743fa6f32e1db0e14b7656d89d2c389aefa5699d51f4a1ec44"
    sha256 cellar: :any,                 arm64_monterey: "f575da591368e6d64fd9782dde681cbed7f2ceba128d39a60af88a7181df0558"
    sha256 cellar: :any,                 arm64_big_sur:  "c0b793b4fea6d41e346b8ec516ac44da6b462474c2d500553daf98efe1a248ec"
    sha256 cellar: :any,                 ventura:        "3913b21d06ca620b190c8d3944251b1c0206f38299f4721e1c34019fda34e6fe"
    sha256 cellar: :any,                 monterey:       "5c7fb0e1f6e486b60ba34cc224fa4e064713aeafcf1d68c76ec12701e3af8beb"
    sha256 cellar: :any,                 big_sur:        "39c8b879b6585cfa8b0d276ed4dfbffc304ec848bb0e4718733f93f2208b4346"
    sha256 cellar: :any,                 catalina:       "7d662588e0d7d35132dff799ea997e78323b777242f2da4027dd17963c0544ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c0190ff3abf6731cd3cda773d8f20fc272ebcb7e05612c29b8615e8cf898f11"
  end

  depends_on "cmake" => :build
  depends_on "arpack"
  depends_on "glpk"
  depends_on "gmp"
  depends_on "openblas"

  uses_from_macos "libxml2"

  def install
    mkdir "build" do
      # explanation of extra options:
      # * we want a shared library, not a static one
      # * link-time optimization should be enabled if the compiler supports it
      # * thread-local storage of global variables is enabled
      # * force the usage of external dependencies from Homebrew where possible
      # * GraphML support should be compiled in (needs libxml2)
      # * BLAS and LAPACK should come from OpenBLAS
      # * prevent the usage of ccache even if it is installed to ensure that we
      #    have a clean build
      system "cmake", "-G", "Unix Makefiles",
                      "-DBUILD_SHARED_LIBS=ON",
                      "-DIGRAPH_ENABLE_LTO=AUTO",
                      "-DIGRAPH_ENABLE_TLS=ON",
                      "-DIGRAPH_GLPK_SUPPORT=ON",
                      "-DIGRAPH_GRAPHML_SUPPORT=ON",
                      "-DIGRAPH_USE_INTERNAL_ARPACK=OFF",
                      "-DIGRAPH_USE_INTERNAL_BLAS=OFF",
                      "-DIGRAPH_USE_INTERNAL_GLPK=OFF",
                      "-DIGRAPH_USE_INTERNAL_GMP=OFF",
                      "-DIGRAPH_USE_INTERNAL_LAPACK=OFF",
                      "-DBLA_VENDOR=OpenBLAS",
                      "-DUSE_CCACHE=OFF",
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
        igraph_diameter(&graph, &diameter, 0, 0, 0, 0, IGRAPH_UNDIRECTED, 1);
        printf("Diameter = %f\\n", (double) diameter);
        igraph_destroy(&graph);
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}/igraph", "-L#{lib}",
                   "-ligraph", "-lm", "-o", "test"
    assert_match "Diameter = 8", shell_output("./test")
  end
end
