class Libnetworkit < Formula
  desc "NetworKit is an OS-toolkit for large-scale network analysis"
  homepage "https://networkit.github.io"
  url "https://github.com/networkit/networkit/archive/refs/tags/11.1.tar.gz"
  sha256 "c8db0430f6d7503eaf1e59fbf181374dc9eaa70f572c56d2efa75dd19a3548a9"
  license "MIT"

  livecheck do
    formula "networkit"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5d0045a902e874098c38bf7c3eba789e8d1d36343f1a58b874c5ae002e771216"
    sha256 cellar: :any,                 arm64_sonoma:  "9bc6b2bb82c01385f9270daaf103455cc879931b6565ff813501763885d74e9b"
    sha256 cellar: :any,                 arm64_ventura: "98b8837808c1cc14fd94b86840a9f68ef5ee4859949de8fa4e4b2ce2cb4f5609"
    sha256 cellar: :any,                 sonoma:        "1b26f3f2939058fff6be5f098275d150ff192ea5d8dd667677979a542df76883"
    sha256 cellar: :any,                 ventura:       "92e49a66eaa9eba680dd1f1bc37b94ae9af79b273a1dae4ddedae6a883745301"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd31d28f3fcb0bba6ad090cfd9c6a6cb2a24ec55b1c05f4a1eb3ad2feb02dc50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32564d543c7c121b193cb9c2d2c769e7f7770165e131037e49cdfc33449a8ace"
  end

  depends_on "cmake" => :build
  depends_on "tlx"
  depends_on "ttmath"

  on_macos do
    depends_on "libomp"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DNETWORKIT_EXT_TLX=#{Formula["tlx"].opt_prefix}",
                    "-DNETWORKIT_CXX_STANDARD=20",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <networkit/graph/Graph.hpp>
      int main()
      {
        // Try to create a graph with five nodes
        NetworKit::Graph g(5);
        return 0;
      }
    CPP
    omp_flags = OS.mac? ? ["-I#{Formula["libomp"].opt_include}"] : []
    system ENV.cxx, "-std=c++20", "test.cpp", "-L#{lib}", "-lnetworkit", "-o", "test", *omp_flags
    system "./test"
  end
end
