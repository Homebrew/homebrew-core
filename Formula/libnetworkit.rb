class Libnetworkit < Formula
  desc "NetworKit is an OS-toolkit for large-scale network analysis"
  homepage "https://networkit.github.io"
  url "https://github.com/networkit/networkit/archive/10.0.tar.gz"
  sha256 "77187a96dea59e5ba1f60de7ed63d45672671310f0b844a1361557762c2063f3"
  license "MIT"

  livecheck do
    formula "networkit"
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "f412ddb92c943b849582a36a9acb6b4deefff24098a158ed911c9b73fba09613"
    sha256 cellar: :any,                 arm64_big_sur:  "f35f2328303856caa57b80f77eb7d086e54b8eb69ef5fdd90095001a3c7ee75e"
    sha256 cellar: :any,                 monterey:       "02e0ce1069e1d3b420da7cc290255d9f2c0c7fb166bb575b8b219416fa9c6f1f"
    sha256 cellar: :any,                 big_sur:        "8a7b5ed41ed3d65512547ac593df74db3af3dcd70547996775f434d92d0d24c4"
    sha256 cellar: :any,                 catalina:       "86fe07599074e4be03ba5aa653f49f995aa9353dee1f98427b7b68d80542e18b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "944d9df37170ba7101900432c4e1bca1e8d742f11429387f59d604d645a7b718"
  end

  depends_on "cmake" => :build
  depends_on "tlx"
  depends_on "ttmath"

  on_macos do
    depends_on "libomp"
  end

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DNETWORKIT_EXT_TLX=#{Formula["tlx"].opt_prefix}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <networkit/graph/Graph.hpp>
      int main()
      {
        // Try to create a graph with five nodes
        NetworKit::Graph g(5);
        return 0;
      }
    EOS
    omp_flags = OS.mac? ? ["-I#{Formula["libomp"].opt_include}"] : []
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lnetworkit", "-o", "test", "-std=c++14", *omp_flags
    system "./test"
  end
end
