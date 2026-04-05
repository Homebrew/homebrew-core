class Maxflow < Formula
  desc "Implementation of the maxflow algorithm"
  homepage "https://github.com/gerddie/maxflow"
  url "https://github.com/gerddie/maxflow/archive/1e014806dc499143ba570341902ac13154dbd29c.tar.gz"
  version "20210122"
  sha256 "159d6ecc2c8b891b38f65b4145113344511e4b26ccdebef332233f5b2b16176f"
  license "GPL-3.0-or-later"
  head "https://github.com/gerddie/maxflow.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  def install
    args = %w[
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    ]

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    prefix.install "GPL.TXT"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <maxflow/graph.h>

      int main() {
          typedef maxflow::Graph<int,int,int> GraphType;
          GraphType *g = new GraphType(2, 1);

          g->add_node(2);

          // Node 0: connected to source with capacity 10
          g->add_tweights(0, 10, 0);
          // Node 1: connected to sink with capacity 5
          g->add_tweights(1, 0, 5);
          // Edge between them: capacity 2
          g->add_edge(0, 1, 2, 0);

          int flow = g->maxflow();

          delete g;

          // The max flow here is actually 2 (Source -> 0 -> 1 -> Sink)
          // because Node 0 has no direct path to Sink and Node 1
          // has no direct path from Source.
          return (flow == 2) ? 0 : 1;
      }
    CPP
    flags = shell_output("pkg-config --cflags --libs maxflow").chomp.split
    system ENV.cxx, "test.cpp", "-o", "test", *flags, "-std=c++11"
    system "./test"
  end
end
