class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.6/astyle-3.6.tar.bz2"
  sha256 "f894429b198b500d51a06a47d229881c5f7c8cffb42a423d646e86c53155f1a9"
  license "MIT"
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  livecheck do
    url :stable
    regex(%r{url=.*?/astyle[._-]v?(\d+(?:\.\d+)+)(?:[._-]linux)?\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ecd3c0f890a504ccd62f9aa8fe84d81badd207b63a1819ebb06cfb0bff590ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "258801359f254ac771e95dd19a1f2c4e7edf6594927564bd525ff6fa29b4e1b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f8ccac661dc26f4d9d6821a99e2e1aa21bb1598dababa121eb9f0905ff86d57"
    sha256 cellar: :any_skip_relocation, sonoma:         "afe0cdc90d21c7ce441490bf448e8074f682a84f508ccea00857b95175d96ec1"
    sha256 cellar: :any_skip_relocation, ventura:        "34e1b2ea516fe12ca6e20d7f75e45bad6572d51f5398d8db0742b2a5f9c2d968"
    sha256 cellar: :any_skip_relocation, monterey:       "a887b3790ab19ad23016d586c9d691d23ba6d79846e250f0b2f8f06f84fe2b98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d41755aaccbe1700c08f0458aa73b5d8a2181de4b2292273c0224c93fcf84407"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    man1.install "man/astyle.1"
  end

  test do
    (testpath/"test.c").write("int main(){return 0;}\n")
    system bin/"astyle", "--style=gnu", "--indent=spaces=4",
           "--lineend=linux", "#{testpath}/test.c"
    assert_equal File.read("test.c"), <<~EOS
      int main()
      {
          return 0;
      }
    EOS
  end
end
