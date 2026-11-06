class Libnetworkit < Formula
  desc "NetworKit is an OS-toolkit for large-scale network analysis"
  homepage "https://networkit.github.io"
  url "https://github.com/networkit/networkit/archive/refs/tags/11.3.tar.gz"
  sha256 "5aa5813110438270e9bb83c73f597943c4c5bedd5a9634fdaf5f2052a0053ba4"
  license "MIT"
  compatibility_version 1

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

  # Must match the `extlibs/dhb` submodule pinned by this release
  resource "dhb" do
    url "https://github.com/hu-macsy/dhb/archive/fb413abb5936ccf30d47e30a448cb8799c63b127.tar.gz"
    version "fb413abb5936ccf30d47e30a448cb8799c63b127"
    sha256 "3a0b726ce537359568cdf5e9ac73ff9606d7e6def1bf208a51d8f6971b3c0c2b"

    livecheck do
      url "https://api.github.com/repos/networkit/networkit/contents/extlibs/dhb?ref=#{LATEST_VERSION}"
      strategy :json do |json|
        json["sha"]
      end
    end
  end

  deny_network_access!

  def install
    resource("dhb").stage buildpath/"extlibs/dhb"
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
