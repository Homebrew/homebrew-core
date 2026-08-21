class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.6/astyle-3.6.18.tar.bz2"
  sha256 "d4fc433cfeacc952de295961bc8ae9eab722e08580baa6c1e8e7b39a7a2fbb48"
  license "MIT"
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  livecheck do
    url :stable
    regex(%r{url=.*?/astyle[._-]v?(\d+(?:\.\d+)+)(?:[._-]linux)?\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f44c126a208d5e6c1277c9c7722bd20fb9ae1da3e2781950487ed226c6a63a0e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8a747bdb1accf93177d97ded09a1a7c23bf199a438b35a87b24c8cddd9367c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d39d060d92601f73dcc25d3b1837ac41e5bc4b8f31471ad87e73c34a91f573f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "648e3c6ca5ca7af567625bb1729e5575d06c47b1e0e56e7d6a8889844aa125bf"
    sha256 cellar: :any,                 arm64_linux:   "70c6838fa6012874469d740318aeffb96891fc1d6b0ab961bef0b20d7241c176"
    sha256 cellar: :any,                 x86_64_linux:  "89f81baf1877187103cb38dec4f9e7409ee35e843f3d31289c3716bc0f8fcaa5"
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
           "--lineend=linux", testpath/"test.c"
    assert_equal File.read("test.c"), <<~C
      int main()
      {
          return 0;
      }
    C
  end
end
