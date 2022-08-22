class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  url "https://github.com/CastXML/CastXML/archive/v0.4.6.tar.gz"
  sha256 "8dcdbc1f23a130e4bdb0b09f57c30761a02a346b4db4037555048af2a293d66a"
  license "Apache-2.0"
  revision 1
  head "https://github.com/CastXML/castxml.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d1d99628e0e867b8b168b12af0e4ac5e510e39fa6b48a7d303520fa2ada90b4e"
    sha256 cellar: :any,                 arm64_big_sur:  "c70f39cda0cb33152690bf38f9a43977182f75504fb86a870728241f39432f33"
    sha256 cellar: :any,                 monterey:       "2e91532b9cfefcbdaafbf64b18a21e7219446431b7c9f0ba0e12f90257fb1b69"
    sha256 cellar: :any,                 big_sur:        "02dfb93291323d19131417c662d642f183952f7aa1410e81f9d4c3690d3f44e6"
    sha256 cellar: :any,                 catalina:       "40d4626864f888105a1e03f35c1afd49eb062d66ac5b756d8342ae5ccf208242"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "946090879b49cf6797843fd5686013314aabbc155b093b6369f10de6a4552471"
  end

  depends_on "cmake" => :build
  depends_on "llvm@14"
  uses_from_macos "llvm" => :test # Our test uses `clang++`.

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      int main() {
        return 0;
      }
    EOS
    system bin/"castxml", "-c", "-x", "c++", "--castxml-cc-gnu", "clang++",
                          "--castxml-gccxml", "-o", "test.xml", "test.cpp"
  end
end
