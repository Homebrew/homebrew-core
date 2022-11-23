class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  url "https://github.com/CastXML/CastXML/archive/v0.4.8.tar.gz"
  sha256 "c8cb5edba35f76b0391a5be96a0a1efacc73ffdbe7ca4e62b4484ddfdbab15f5"
  license "Apache-2.0"
  head "https://github.com/CastXML/castxml.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "34d75322ed267236a1facf829302ebb49c1db1bbdac37c68f253524535249aec"
    sha256 cellar: :any,                 arm64_monterey: "0a7d4fc4884d23139056a348ef4f4d41a471e640da1ffae59681bb3c221a962e"
    sha256 cellar: :any,                 arm64_big_sur:  "2ec62c3ccc8d08a43714a062713a296405ecb8a27890b40bc2ead8ec2a59ebd0"
    sha256 cellar: :any,                 monterey:       "3a4c7833be530288fc608eb18e1c683ee74c101d3bf77ee4de31b2b43d27bd54"
    sha256 cellar: :any,                 big_sur:        "cb4caa42f30b1726609fba40b918a5fba11a22c24d7ec4c23e50b74ae616659e"
    sha256 cellar: :any,                 catalina:       "8ce7421f7875ccf09358dfb1736a1e3c1368c930139f418022935969593bd5be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aec6ff4582dbd3b5555a1074111657ac726b162d117937903ad81da36a78de22"
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
