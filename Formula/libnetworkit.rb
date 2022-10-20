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
    rebuild 2
    sha256 cellar: :any,                 arm64_monterey: "6bc1e0d3d759aed8800327120850737934ae106dcd9d6c66efb348b7c9e67b1e"
    sha256 cellar: :any,                 arm64_big_sur:  "8cb2f1613a8e9154ac7f6fa74a8b5175ae2ae599532be959bf3425a8a2e3a27b"
    sha256 cellar: :any,                 monterey:       "666f4a00feef2523ba39656fc77e2edadb70902b805ea54b37bfb282b94bae88"
    sha256 cellar: :any,                 big_sur:        "3203b49d96a9df9e76e7d7f38133f7657a0121728e164c7dfa12f6f83ce67398"
    sha256 cellar: :any,                 catalina:       "b6624ef3b304d677a9f454342dfd61281834f177a72205bf9f25f47b8e390344"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8576a8e5f2dcbe074f3c34c15ae0fa8b9f77841ab6eaa7c65da026b1a73bf33"
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
