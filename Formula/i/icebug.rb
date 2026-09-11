class Icebug < Formula
  desc "High-performance graph analytics backed by read-only memory"
  homepage "https://github.com/Ladybug-Memory/icebug"
  url "https://github.com/Ladybug-Memory/icebug/archive/refs/tags/13.3.tar.gz"
  sha256 "28acfdf7ae257d96fe30f6ea8f85db4b86b45d81281b3e8ccb7d321fe9f8457b"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "cmake" => :build
  depends_on "apache-arrow"
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

    # `cmake --install` only ships *.hpp headers, so install the remaining
    # *.tpp implementation files included by the public headers.
    Dir["include/networkit/**/*.tpp"].each do |header|
      (include/File.dirname(header.delete_prefix("include/"))).install header
    end
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
    flags = %W[-I#{formula_opt_include("apache-arrow")} -I#{formula_opt_include("tlx")}"]
    flags << "-I#{formula_opt_include("libomp")}" if OS.mac?
    system ENV.cxx, "-std=c++20", "test.cpp", "-L#{lib}", "-lnetworkit", "-o", "test", *flags
    system "./test"
  end
end
