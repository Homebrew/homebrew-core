class Libnetworkit < Formula
  desc "NetworKit is an OS-toolkit for large-scale network analysis"
  homepage "https://networkit.github.io"
  url "https://github.com/networkit/networkit/archive/8.1.tar.gz"
  sha256 "0a22eb839606b9fabfa68c7add12c4de5eee735c6f8bb34420e5916ce5d7f829"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "727074b6cac4f69e9c08ce93977f8532b6a1d23d6202b1d90170afdfbd33ac21"
    sha256 cellar: :any, big_sur:       "7d64ac4870fb93c344fd0b736780fcd24dd4f97edd78ba9230695182509df683"
    sha256 cellar: :any, catalina:      "06734dd0d47c1c6a97d97f9e4fc0a0ec8a15048d30a615b0b098980e1412d74f"
    sha256 cellar: :any, mojave:        "fcad0e262612348b5f66af67d15ca7548797ed8c29a673d7a34c0ff28e7e52ad"
  end

  depends_on "cmake" => :build
  depends_on "libomp"
  depends_on "tlx"

  def install
    mkdir "build" do
      system "cmake", ".", *std_cmake_args,
                           "-DNETWORKIT_EXT_TLX=#{Formula["tlx"].opt_prefix}",
                           "-DOpenMP_CXX_FLAGS='-Xpreprocessor -fopenmp -I#{Formula["libomp"].opt_prefix}/include'",
                           "-DOpenMP_CXX_LIB_NAMES='omp'",
                           "-DOpenMP_omp_LIBRARY=#{Formula["libomp"].opt_prefix}/lib/libomp.dylib",
                           ".."
      system "make", "install"
    end
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
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lnetworkit", "-o", "test", "-std=c++11"
    system "./test"
  end
end
