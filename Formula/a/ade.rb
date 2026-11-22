class Ade < Formula
  desc "Graph construction, manipulation, and processing framework"
  homepage "https://github.com/opencv/ade"
  url "https://github.com/opencv/ade/archive/refs/tags/v0.1.2e.tar.gz"
  version "0.1.2e"
  sha256 "107711887d413127955d64a0e42974ec379c1ebb81832c79a21a9e3a2110e4bf"
  license "Apache-2.0"
  compatibility_version 1

  bottle do
    manifest_sha256 "61b3851c2f62547f21af26e4906bcfeaf0f60edf8237589dbd25122d70777366"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "647f807245e7aed6bf61472131e4dbe3099b90ad907de86c3a53850b6b5bbc99"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "28a5c2c75e9e10766798cbe442a18a0ff981ed2c58e4127cd7b09f093db62ded"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9429c6c17431b9959a479d8067b6f30245a7f9dbd480d1b18a546cd08430b62a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ec746a4b86ff2e504ee513e6c94bf11b7a38b6a9a23cc0fb648d125e932c5251"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f18d80c05f9a0cad0b695c63573eddb6c24c58c13efac13ea559ef3e77addb4e"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <cassert>
      #include <ade/graph.hpp>

      int main(void) {
        ade::Graph graph;
        auto n1 = graph.createNode();
        auto n2 = graph.createNode();
        auto n3 = graph.createNode();
        graph.link(n1, n2);
        graph.link(n1, n3);
        assert(graph.nodes().size() == 3);
        assert(n1->inEdges().size() == 0);
        assert(n1->outEdges().size() == 2);
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-o", "test", "-L#{lib}", "-lade"
    system "./test"
  end
end
