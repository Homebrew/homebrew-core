class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  url "https://github.com/CastXML/CastXML/archive/v0.5.1.tar.gz"
  sha256 "a7b40b1530585672f9cf5d7a6b6dd29f20c06cd5edf34ef34c89a184a4d1a006"
  license "Apache-2.0"
  head "https://github.com/CastXML/castxml.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "89ebbd917b3524332a8ae3a99bba8088208c76654371e9dde584af11769bbb2f"
    sha256 cellar: :any,                 arm64_monterey: "b954354e40feff11a048ee127bdee0ed0b1690df13490f08f04fd90c4518c64e"
    sha256 cellar: :any,                 arm64_big_sur:  "43e7f0742f9a89d2ac31287084887c9565e146bfabc8fea8e7b7b81770189ed6"
    sha256 cellar: :any,                 ventura:        "59a1532bfbbf9daac9d8d6537b569eb074b4e0ce590ae3f217958c41434b8c23"
    sha256 cellar: :any,                 monterey:       "befc46698dac914fb049d9cebef13fda3b02e92e0ba98c2744e86eacd8537ddc"
    sha256 cellar: :any,                 big_sur:        "bb44d192879ac329486a36b6e0a70d955eb8a371e224966eb3821ebb183588fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22a37f5f6326122e7a542a02c6659baed4e83e0014f15e59c046e3de0186a6a3"
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
