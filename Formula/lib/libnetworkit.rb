class Libnetworkit < Formula
  desc "NetworKit is an OS-toolkit for large-scale network analysis"
  homepage "https://networkit.github.io"
  url "https://github.com/networkit/networkit/archive/refs/tags/11.2.2.tar.gz"
  sha256 "04fffd0f801a91524a6dc2643f7d262e79600b086e4688bcb1b7988b2b5448dd"
  license "MIT"

  livecheck do
    formula "networkit"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "3fb12d60ade5660a3e813d9be1c6768dd16f5d17aff4cced23d82cc60a0671ed"
    sha256 cellar: :any, arm64_tahoe:       "0b16dca753bec93f58f09b63ec7449c1fc361bca83f1722f6b77f1b691c9fde1"
    sha256 cellar: :any, arm64_sequoia:     "f43a37fc50f836ba1bc754448bbdf7aa7038c2d65fc31cfb950ab3f6744a2d4a"
    sha256 cellar: :any, arm64_linux:       "a46d3d36083b57d66cd56a24239b89aa1cda60a077ecd914533c323c214b304a"
    sha256 cellar: :any, x86_64_linux:      "7eb623aae119b462f9ff7b12ccbfccb26c3b6772ae78971e8d22f490066fd75e"
  end

  depends_on "cmake" => :build
  depends_on "tlx"
  depends_on "ttmath"

  on_macos do
    depends_on "libomp"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DNETWORKIT_EXT_TLX=#{formula_opt_prefix("tlx")}",
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
    omp_flags = OS.mac? ? ["-I#{formula_opt_include("libomp")}"] : []
    system ENV.cxx, "-std=c++20", "test.cpp", "-L#{lib}", "-lnetworkit", "-o", "test", *omp_flags
    system "./test"
  end
end
