class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  url "https://github.com/CastXML/CastXML/archive/refs/tags/v0.6.5.tar.gz"
  sha256 "fea4754bdb1fb4496fec12352e2bd07854843aa757e85d0553f224ff0111c482"
  license "Apache-2.0"
  revision 1
  head "https://github.com/CastXML/castxml.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bcd607459da2d680ee7df51f317e6db561915753b4076df5a0d6979f6c5bbd97"
    sha256 cellar: :any,                 arm64_ventura:  "dfd71273c8bcb3894d5d7673eee32e7adf8513df5b8f277ae5ce3bb45141bdda"
    sha256 cellar: :any,                 arm64_monterey: "0506d2ecd98a1b9f36fda32026a22dd9c373433b884c7bae19245d743caec157"
    sha256 cellar: :any,                 sonoma:         "820ae2d36800d1825fd08eb31b0b54b42cfd6276b16314b83fd1a4b2ac3b8bd3"
    sha256 cellar: :any,                 ventura:        "4812b477bd80827d5aef15a97075caddd6b995efd154b12aeda98efbe9e80759"
    sha256 cellar: :any,                 monterey:       "717394c6574f58af2edab4e971578348e1a02dc6b75837d45c5514b8a3c1778f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "067e97b005c9fb5a85003b676d4c71b9f16a585a52d124f019607d0996a727c5"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

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
    system bin/"castxml", "-c", "-x", "c++", "--castxml-cc-gnu", ENV.cxx,
                          "--castxml-gccxml", "-o", "test.xml", "test.cpp"
  end
end
