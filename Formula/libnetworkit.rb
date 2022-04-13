class Libnetworkit < Formula
  desc "NetworKit is an OS-toolkit for large-scale network analysis"
  homepage "https://networkit.github.io"
  url "https://github.com/networkit/networkit/archive/9.1.1.tar.gz"
  sha256 "0376b3b7b8ba1fefb46549c7dd2cf979237a24708293715b1da92b4da272a742"
  license "MIT"

  livecheck do
    formula "networkit"
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "d70f28d4cd0e0f131bf702bc28145ac29c6bed7735c56ed32a7d172f22a287be"
    sha256 cellar: :any, arm64_big_sur:  "e980cfd47eea34350c5fefd5f293413b29396b1320b2661182db608596edabe1"
    sha256 cellar: :any, monterey:       "b795b14c903c6280b050abaa2b36f7a692ec3b4422b46f45e67fe9d8a3424edb"
    sha256 cellar: :any, big_sur:        "b3d03f22419474b830163e6f67a113c96393095311ae3014f7b09c7e52ba22ca"
    sha256 cellar: :any, catalina:       "43e0aecc9ced86dd1e9cfcbef96965bbbe767beb9114f095952c8b8cf8ab6317"
  end

  depends_on "cmake" => :build
  depends_on "tlx"

  on_macos do
    depends_on "libomp"
  end

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    mkdir "build" do
      flags = ["-DNETWORKIT_EXT_TLX=#{Formula["tlx"].opt_prefix}"]
      # GCC includes libgomp for OpenMP support and does not need any extra flags to use it.
      if OS.mac?
        flags += [
          "-DOpenMP_CXX_FLAGS='-Xpreprocessor -fopenmp -I#{Formula["libomp"].opt_prefix}/include'",
          "-DOpenMP_CXX_LIB_NAMES='omp'",
          "-DOpenMP_omp_LIBRARY=#{Formula["libomp"].opt_prefix}/lib/libomp.dylib",
        ]
      end
      system "cmake", ".", *std_cmake_args, *flags, ".."
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
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lnetworkit", "-o", "test", "-std=c++14"
    system "./test"
  end
end
