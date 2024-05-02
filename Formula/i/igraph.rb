class Igraph < Formula
  desc "Network analysis package"
  homepage "https://igraph.org/"
  url "https://github.com/igraph/igraph/releases/download/0.10.11/igraph-0.10.11.tar.gz"
  sha256 "f7aa3c7addce69538892c185055d59719ee1587f58ce0ae4fec8ddd072946d63"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1e567ab97ae33aaf25ff5ab3d171d2c0541526ef4df6c8e0f4843a501bfa916e"
    sha256 cellar: :any,                 arm64_ventura:  "04ce45ca6db20512296671e2c40d39db807ada410aaf4898f7f7d1707f440881"
    sha256 cellar: :any,                 arm64_monterey: "ba8c63ca3c6a62498c7e62cd8e4e37e2457c51a575c1352e851e701e09c6fabf"
    sha256 cellar: :any,                 sonoma:         "842c44fd5a30e9e6e945b81d66c2282e4ecc73e3f09a96488d39bb51d9ec40ae"
    sha256 cellar: :any,                 ventura:        "a9c3a7066410e7a3d109976fd70248ea5b93c5a67cba90c7125d7dc46cfbe0d1"
    sha256 cellar: :any,                 monterey:       "ebd574d7e0c4f9df89dee5541100027a8ac7b336739e6098772250203c44203b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70045e285382a8f4ab9844934f430b62844b44e569ca7b6b17c00adede395d68"
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
