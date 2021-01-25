class Libnetworkit < Formula
  desc "NetworKit is an OS-toolkit for large-scale network analysis"
  homepage "https://networkit.github.io"
  url "https://github.com/networkit/networkit/archive/7.1.tar.gz"
  sha256 "60026c3be581ae9d5c919c861605082fcb9c8205758b3ddfcde2408153ae166e"
  license "MIT"

  bottle do
    cellar :any
    sha256 "2e0c3e5599416ae8007b4baf2b55fd6f6a63354727bafd978d4f654586c5ae77" => :big_sur
    sha256 "456bcb891377b0666eaa4f068c5e0664b038474b10cb03475068109cc5c06b40" => :arm64_big_sur
    sha256 "ce41e3c47bba5ffc61f1b5ea65b908b64032b1af605e19c8a40f40f26bb946fa" => :catalina
    sha256 "f2dab092758749672edc5058fc89e53da086e1acec7756900be0e0d7d839bf16" => :mojave
    sha256 "94522c74e5a3867137849646c49d0e664fd298db24436bf2bfba2e7d725d9caa" => :high_sierra
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
