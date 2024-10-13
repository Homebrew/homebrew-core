class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  url "https://github.com/CastXML/CastXML/archive/refs/tags/v0.6.8.tar.gz"
  sha256 "b517a9d18ddb7f71b3b053af61fc393dd81f17911e6c6d53a85f3f523ba8ad64"
  license "Apache-2.0"
  revision 2
  head "https://github.com/CastXML/castxml.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "09eeab9e19404218b6f4257df621f695da81d4a16d2d139a81e3816efde16798"
    sha256 cellar: :any,                 arm64_sonoma:  "5902e2b5e7ee77601d3b3b5134e3c75fcf6fd9d1514d944355f0ee750bf3eddf"
    sha256 cellar: :any,                 arm64_ventura: "5022195efbecd4ab3e41df8d8f71409064e55c849883e6240abad8124e75f150"
    sha256 cellar: :any,                 sonoma:        "e02a0e5c39a33f65d4f0b3f4c264468e78fe6e6384b886eee80ebf4860371699"
    sha256 cellar: :any,                 ventura:       "44e174548e6919d4f02f7bd072a950a139157ee8d0bf9d2c71f9ae7c70470f66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e4147162020b86e4f1418c85731fb7fe430985d90dcd955b9cdcbfef4d1d8a6"
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
