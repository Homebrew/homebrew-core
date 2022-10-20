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
    sha256 cellar: :any,                 arm64_monterey: "db11dcd3c73d9118eccfbe1a70b181884ecc7cbb8246f6c08d6d6d75fe6e7fb7"
    sha256 cellar: :any,                 arm64_big_sur:  "907e4ff31ea45368b416377d7b394baa443c0eb3a852e1434ebc62335b23c06e"
    sha256 cellar: :any,                 monterey:       "99a3a892e9a61dd36456a3412cecaf8f09df22c27dcecb69333525ac8d6cd594"
    sha256 cellar: :any,                 big_sur:        "08b7dd0bd093f8f6138d86c109370faa79df35d81009143e5bb8fd92e794cb42"
    sha256 cellar: :any,                 catalina:       "e9032635b06d7eaa0d3df0426b7f404f9b4a1b8ca5428e4184eb7e7fe6f7a2cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "120f1c9aadd51bc7559c1b4d76f152dd626ae04b1121ddae3c4cdbb38d277897"
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
