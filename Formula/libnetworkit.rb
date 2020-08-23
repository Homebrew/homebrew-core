class Libnetworkit < Formula
  desc "NetworKit is an OS-toolkit for large-scale network analysis"
  homepage "https://networkit.github.io"
  url "https://github.com/networkit/networkit/archive/7.0.tar.gz"
  sha256 "4faf16c5fae3e14d3c1b6f30e25c6e093dcf6a3dbf021235f3161ac2a527f682"
  license "MIT"

  bottle do
    cellar :any
    sha256 "86915bb4086ab367364d03ae45b1228aa0b788facda6daf18e0a0adaff9b140e" => :catalina
    sha256 "9b9d3a3e7aa1a6f948a474b14aa251813d96e703eddf2bbc65e1c815e83be564" => :mojave
    sha256 "2b2ae31876287265a67d737efa586d66e839e9fbf648354c53a3222a0c679ae1" => :high_sierra
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
