class Castxml < Formula
  desc "C-family Abstract Syntax Tree XML Output"
  homepage "https://github.com/CastXML/CastXML"
  url "https://github.com/CastXML/CastXML/archive/refs/tags/v0.6.6.tar.gz"
  sha256 "f36ad7bee85a78c57e97311bae3828a70dd02422a2a81ff89e6f62273c682416"
  license "Apache-2.0"
  head "https://github.com/CastXML/castxml.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f9a96dee57c57614bf957bb3b58ede825ce5a45007f8e2446c7b0c88266a88de"
    sha256 cellar: :any,                 arm64_ventura:  "e739f3f9ec53840dcf75957a9f96fb67e86c76264acaa6ae9a287f4c1a711d65"
    sha256 cellar: :any,                 arm64_monterey: "be27ad513e73f7c6a7cb7e3c5c2d2582cc63237fd4bb0610513728e8d54decc8"
    sha256 cellar: :any,                 sonoma:         "ac37eca59eecdae0f95b0e7295e448573f49cb7b251a17856d6be2c6435ec737"
    sha256 cellar: :any,                 ventura:        "7f3c702947943106bd9e5373d50983851ce837716a06daca96e00d398df58687"
    sha256 cellar: :any,                 monterey:       "cb3b5a7ae877bfcb5dab4dca206f43963ceeb8c66f943f9a72a2d3227dba7d7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b30abf1de834f0489ebfdf979c925de518bfe51395efa513d0f8c6750a200f6"
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
