class Libnetworkit < Formula
  desc "NetworKit is an OS-toolkit for large-scale network analysis"
  homepage "https://networkit.github.io"
  url "https://github.com/networkit/networkit/archive/8.0.tar.gz"
  sha256 "cdf9571043edbe76c447622ed33efe9cba2880f887ca231d98f6d3c22027e20e"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "5f2bff7d671e380fdd61d0f19526dca6497ff2846ff0569721b93b7067efa11f"
    sha256 cellar: :any, big_sur:       "af356f704e84e2bd01c3eba35b52db809985536c2be04cc0642a2fd1599db6e0"
    sha256 cellar: :any, catalina:      "66137ce8956685d9ff6a905553e4275f0eb963a439900c111fa1568f03c4462d"
    sha256 cellar: :any, mojave:        "6a6dc69af2c96f1a4745e480026dd093f59369018965f1e85b7e0a7b5a03a29a"
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
