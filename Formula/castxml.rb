class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  url "https://github.com/CastXML/CastXML/archive/v0.4.5.tar.gz"
  sha256 "007f6d073165e150df0e40e1ec331f6f94304684af9eed3b0e5dabaebcfb1197"
  license "Apache-2.0"
  head "https://github.com/CastXML/castxml.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a1b3a58769ebb3cdf0e42fd9ea907b34155e1bff987988936e810baa7cec08cc"
    sha256 cellar: :any,                 arm64_big_sur:  "1b2d81fc9a9dd3830f323d70ed4f965a756394cae2d85d717802e577bfccc007"
    sha256 cellar: :any,                 monterey:       "c79f9f01ef4de2a7ca9b982f9934d92eab64447c2ff4f6b0a51c203b6c3b8856"
    sha256 cellar: :any,                 big_sur:        "26d6c7f54cfa7c772aee126440a5b39c9ea7849d1a835f964a190bdc1832b17c"
    sha256 cellar: :any,                 catalina:       "a39f4d192bc2aa37dd111375d5d1771cc1ef3606333c51214f52746fc02549a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64a4eba1043aaca30763bbbe880491391b6b3260710f636521e30e4a58ea1a92"
  end

  depends_on "cmake" => :build
  depends_on "llvm"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      int main() {
        return 0;
      }
    EOS
    system "#{bin}/castxml", "-c", "-x", "c++", "--castxml-cc-gnu", "clang++",
                             "--castxml-gccxml", "-o", "test.xml", "test.cpp"
  end
end
