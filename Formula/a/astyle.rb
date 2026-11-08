class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.6/astyle-3.6.23.tar.bz2"
  sha256 "9c29649223429d0a8a9fd775767f9d268e2624ccc39aaba7571493c5787c00af"
  license "MIT"
  compatibility_version 1
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  livecheck do
    url :stable
    regex(%r{url=.*?/astyle[._-]v?(\d+(?:\.\d+)+)(?:[._-]linux)?\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a9a85e8797494baa65e7c749d8579936b4a18226b90ce7900b23fea7c920f498"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fd8a7b6ce76398e2d6eb70e80310f996d13a9bb75f3bcffae3218e139efe6232"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0fc5402d529783d1c893d53794cd44da4299430508e0544876422b7076b5c003"
    sha256 cellar: :any,                 arm64_linux:       "f7896967ce37449cc4e2a4d25baaa0626477a5a1fe90d88af0c87fe4e93aaec8"
    sha256 cellar: :any,                 x86_64_linux:      "d7ccf2b357b01e6e34a736d144440bbb37d22a3292ab064287266292fe73848c"
  end

  depends_on "cmake" => :build

  deny_network_access!

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
