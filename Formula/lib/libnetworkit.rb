class Libnetworkit < Formula
  desc "NetworKit is an OS-toolkit for large-scale network analysis"
  homepage "https://networkit.github.io"
  url "https://github.com/networkit/networkit/archive/refs/tags/10.1.tar.gz"
  sha256 "35d11422b731f3e3f06ec05615576366be96ce26dd23aa16c8023b97f2fe9039"
  license "MIT"

  livecheck do
    formula "networkit"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "59283b3cad749dcb4e6858342c00a674fa7de3736cbf61894d9e85234fd18d84"
    sha256 cellar: :any,                 arm64_monterey: "31deb32643f4cbe9550093bf3035e8c03d9e93f49a0fc451883291165e192516"
    sha256 cellar: :any,                 arm64_big_sur:  "60d4901b43ef884f663c2cb359cb20e7b599f30476dd1eae03cbe22eb28c78bb"
    sha256 cellar: :any,                 ventura:        "b03e53fdd18e51965e65464646d6833816570f1ff151ce9f86e31b43ed91a0c2"
    sha256 cellar: :any,                 monterey:       "f113a062f3bc88e70fc0989fe1d05b2ea4335799397f08d1b0251425b5b4ef5d"
    sha256 cellar: :any,                 big_sur:        "19cff3fc591f90da9b9575edc56d06830257ff5fd46243c54890b406b1a62555"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7ebf4ad519f67ba9a1e66cb198b5b5f2f9777a9e4ad247e5c21c2a29687b636"
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
