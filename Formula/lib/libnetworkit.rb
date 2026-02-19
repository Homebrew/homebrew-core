class Libnetworkit < Formula
  desc "NetworKit is an OS-toolkit for large-scale network analysis"
  homepage "https://networkit.github.io"
  url "https://github.com/networkit/networkit/archive/refs/tags/11.2.1.tar.gz"
  sha256 "969718847465937086728a884b5f143d7f36cfd3f6cdc04ef9ae4f64ba61b60c"
  license "MIT"

  livecheck do
    formula "networkit"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "77c3f853f13a533978f790671a938a0341ae8d77d02698d9d1d89efd51d8c45e"
    sha256 cellar: :any,                 arm64_sequoia: "51c9d11342d2e0cd45b9ef5e2c7ff6834b6582398dec59ce37cafe91e1ccee27"
    sha256 cellar: :any,                 arm64_sonoma:  "f50f9503044e1021d1d61169ecd04fe907148de0745b93e7cdb095c7d0308d3c"
    sha256 cellar: :any,                 sonoma:        "a47488310d81eff3eac5596af4099e3585896d2828f1bdf51524b3d5bc8be76a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7369fce424d18d4e14a1125462f5bd8543fe2bbb1112b1699256f04f54f375d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47b4cb78951b041733d9d8f352e5fb4b7d48ab6747ad41ad05c31e9d25ffa150"
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
