class Libnetworkit < Formula
  desc "NetworKit is an OS-toolkit for large-scale network analysis"
  homepage "https://networkit.github.io"
  url "https://github.com/networkit/networkit/archive/refs/tags/11.0.tar.gz"
  sha256 "3cba54b384db4adfd88c984805647a3b74ed52168b6178cba6dd58f1cbd73120"
  license "MIT"

  livecheck do
    formula "networkit"
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "ffb3aa63de3e3cb1f54e74b8b82c52e9483eb095b872cbfa1160760227594b6f"
    sha256 cellar: :any,                 arm64_sonoma:   "35247ec81aa371424653681f3d267f554791441ec7097fe1f0531498581091fe"
    sha256 cellar: :any,                 arm64_ventura:  "62f3647720ab3848ab4db7e5b437c3cb895f0f92ceb282ef3a8c436251566841"
    sha256 cellar: :any,                 arm64_monterey: "b8e918851ccbb196bcf2bc59183f4ac6cd4b35144d2b65626f3639a0d1a47174"
    sha256 cellar: :any,                 sonoma:         "1e75379743db5e3a1e6ab2c4d7a9f6aa1040fd402249b1ed64fcd6c7ee30e567"
    sha256 cellar: :any,                 ventura:        "07d2338f357a0afa08f64ec9021859a003949bc6c60c4363d058639a91e6f35a"
    sha256 cellar: :any,                 monterey:       "73369add0bbe7627aac329ff24d64d1f47adc151b34184e32da5578e10c7a471"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc9b743d4a5ba133a23756198605f0af47d6665f6123411c42e124a0afc6da76"
  end

  depends_on "cmake" => :build
  depends_on "tlx"
  depends_on "ttmath"

  on_macos do
    depends_on "libomp"
  end

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DNETWORKIT_EXT_TLX=#{Formula["tlx"].opt_prefix}",
                    "-DNETWORKIT_CXX_STANDARD=17",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <networkit/graph/Graph.hpp>
      int main()
      {
        // Try to create a graph with five nodes
        NetworKit::Graph g(5);
        return 0;
      }
    EOS
    omp_flags = OS.mac? ? ["-I#{Formula["libomp"].opt_include}"] : []
    system ENV.cxx, "-std=c++17", "test.cpp", "-L#{lib}", "-lnetworkit", "-o", "test", *omp_flags
    system "./test"
  end
end
