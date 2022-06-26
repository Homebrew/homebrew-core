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
    sha256 cellar: :any,                 arm64_monterey: "e2919d44cec2eafbbe58c3fee2681daf09958abbb9ba528eefe96f7df6256c00"
    sha256 cellar: :any,                 arm64_big_sur:  "8e05afb0ae9e15fec6bf8399b53a552adf98925b9589d78793b21aadb27a46ec"
    sha256 cellar: :any,                 monterey:       "9085962ca2f6b0039a9792ea6f0ae961afef99a5db473d89d9032ece3cf3a580"
    sha256 cellar: :any,                 big_sur:        "b163a4d4dddf4bd99b93c4721d78641055076e35a0d479c0cfd13d32d21cb133"
    sha256 cellar: :any,                 catalina:       "f90b31a3102703560a6e12a5d538cd0a58022bc009930c94719c61ef155da9bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "630f9f76898951016ab2e198933cb737ba19f1a98af8025af791b0a83a08fe36"
  end

  depends_on "cmake" => :build
  depends_on "tlx"
  depends_on "ttmath"

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
