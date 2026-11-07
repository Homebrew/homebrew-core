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
    sha256 cellar: :any, arm64_golden_gate: "b1c4aee8b66167207a5f62aee082bfaabfcb9e178f3e836e829af8f199391c2e"
    sha256 cellar: :any, arm64_tahoe:       "bf10d3a4fe3552ca92ffdf6e790a6a7031179f18aa52e15b7899cb530a9e4edf"
    sha256 cellar: :any, arm64_sequoia:     "e5f5148869a241cf86959f0a37f8cd3f12989d363c08ebb50f208e2ab12ce0dd"
    sha256 cellar: :any, arm64_linux:       "ff30d644ee7dc57760d8017546933ed9437dd357e7d1e9b49354f161b4704fcc"
    sha256 cellar: :any, x86_64_linux:      "a2e4f0d17af1c82ae577416e3d2a2b741c611ac8bbb5062c2532e815a065b3c7"
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
