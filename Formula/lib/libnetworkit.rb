class Libnetworkit < Formula
  desc "NetworKit is an OS-toolkit for large-scale network analysis"
  homepage "https://networkit.github.io"
  url "https://github.com/networkit/networkit/archive/refs/tags/11.2.tar.gz"
  sha256 "ed762fb2b893425fe05074fa746db58c1e7bef4d96d9921e72d6ae8ca387f995"
  license "MIT"

  livecheck do
    formula "networkit"
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "87d42f90e50cd58ba0cf64e3d1e84e4087e6fda622075b6d61633578d4ab645e"
    sha256 cellar: :any,                 arm64_sequoia: "3be06a651f594f9b043d6404f498ac690bcb244c7dfdcfa8f56b7901a1c1f369"
    sha256 cellar: :any,                 arm64_sonoma:  "a53c614d4133bbbb02bf5bc3f18243be72f128cb4c38e33f59b385af55092822"
    sha256 cellar: :any,                 sonoma:        "e6e3e7ecc91302bc7f2ab12d282aa14d3f17c2f12792788abf9fa303a4f5fbb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b7b70420dc308d0ab35a8f986876a1b6958f2d835c5482ad86dc6215222347f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfda5c3182496123992a12391492cc1cc8cb6f41ffba784d16a257f14866aa8a"
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
