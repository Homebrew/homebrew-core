class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  url "https://github.com/CastXML/CastXML/archive/v0.5.0.tar.gz"
  sha256 "005d5c6b95d046fcc36703004ca83f4418d94308e039cdb573aa9cdf3a29b643"
  license "Apache-2.0"
  head "https://github.com/CastXML/castxml.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4bac6d4611217c6c30ae0c850ecb1ceea5267ef96ceb192623832ec930b2c0d5"
    sha256 cellar: :any,                 arm64_monterey: "4d3805b1bf5c2c609d0ff58d239f3c357985af15c060afe401bed970b54ed967"
    sha256 cellar: :any,                 arm64_big_sur:  "ece2eeb0fc0902051b9d932c3faf83401de785c778886d78351dd3ce399b4fbf"
    sha256 cellar: :any,                 ventura:        "ca58082f7d6cac2733c3d755ac68ae94d838690a11b2ab41d47e2afc5e924e66"
    sha256 cellar: :any,                 monterey:       "e591f4159e3dd2620c7a2b37e677ad9561a31a9c4e5a5f8933ef3440ac975c36"
    sha256 cellar: :any,                 big_sur:        "1596cc3cc3213000c75ef00c147f761ba18475f396ce867a5c51d9ad1785a12d"
    sha256 cellar: :any,                 catalina:       "e6d1d1a38f1436707bde16929ef307c5d4b0e30e2b6c8e194897cc281aecf9d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c773cc640ad882090e8b7b8f4a032b6ea3d6c63e55f5b0f13142be031dcbbe9"
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
