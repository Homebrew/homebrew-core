class Ade < Formula
  desc "Graph construction, manipulation, and processing framework"
  homepage "https://github.com/opencv/ade"
  url "https://github.com/opencv/ade/archive/refs/tags/v0.1.2e.tar.gz"
  version "0.1.2e"
  sha256 "107711887d413127955d64a0e42974ec379c1ebb81832c79a21a9e3a2110e4bf"
  license "Apache-2.0"
  compatibility_version 1

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
