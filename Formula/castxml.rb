class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  url "https://github.com/CastXML/CastXML/archive/v0.6.1.tar.gz"
  sha256 "7a2e5ae99c66b5b44e682f261248cd874fdd7554f4a24fc31d09ac5b6dcde7e5"
  license "Apache-2.0"
  head "https://github.com/CastXML/castxml.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ec4420fe2c13d8ec8bb2f1eed90efecbfae34141f53e952eb5c0f81ce2f5ef68"
    sha256 cellar: :any,                 arm64_monterey: "193cf1a33c31b804797aa31075001318abec848b41a3c9f7adcd0b250559a5bb"
    sha256 cellar: :any,                 arm64_big_sur:  "804415921c12e80aac8e2ea3a54e4a0df0b68d5c5e8efac8c32753b765c31f6e"
    sha256 cellar: :any,                 ventura:        "a98a9faea2837d6be196aa26f33bb71f7ff9053ca40f5bf2b842d1cf5d393f52"
    sha256 cellar: :any,                 monterey:       "6c3d7fea524c0dd2bdd60684693edef40feb85f5ce5206322abc2981d375c603"
    sha256 cellar: :any,                 big_sur:        "75e03d1fe17f2f10898b6db349bda5c952658ee1719848a3f019dc1509276ffd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3cb365248f39c523ed710a95952dad301e5bc455fccd316b739ff537edce8f6"
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
    system bin/"castxml", "-c", "-x", "c++", "--castxml-cc-gnu", "clang++",
                          "--castxml-gccxml", "-o", "test.xml", "test.cpp"
  end
end
