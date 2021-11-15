class Libnetworkit < Formula
  desc "NetworKit is an OS-toolkit for large-scale network analysis"
  homepage "https://networkit.github.io"
  url "https://github.com/networkit/networkit/archive/9.0.tar.gz"
  sha256 "c574473bc7d86934f0f4b3049c0eeb9c4444cfa873e5fecda194ee5b1930f82c"
  license "MIT"

  livecheck do
    formula "networkit"
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "3edd1ff45863da0ffcaf40846bae8548e8e0b7176ab6b58ce12187fd0c042923"
    sha256 cellar: :any, arm64_big_sur:  "64c44c774f168ca26948606efcdb7169fe4635f691b3d90ed12a433cc3fe45eb"
    sha256 cellar: :any, monterey:       "8762d34771bed0914f9979a054d029b268fe2a95fecb5cab019fc74b8858f296"
    sha256 cellar: :any, big_sur:        "81ff9507c3ebdf80e372d5526d2bae58ef7aa69f983ad0f695965101301dd1d6"
    sha256 cellar: :any, catalina:       "d9dcf7918613bbd1f131697a065e835caa32939beb27365cbfa8d51d40aaf563"
    sha256 cellar: :any, mojave:         "aa47da31ff42b8ab780b33c9fe25308be7a3ee18d45865410584ea2475b51af7"
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
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lnetworkit", "-o", "test", "-std=c++14"
    system "./test"
  end
end
