class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.6/astyle-3.6.27.tar.bz2"
  sha256 "cfb2e432fc03c0da61593c0cedce69111284a620e0c5e969ff3c1e4363f00064"
  license "MIT"
  compatibility_version 1
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  livecheck do
    url :stable
    regex(%r{url=.*?/astyle[._-]v?(\d+(?:\.\d+)+)(?:[._-]linux)?\.t}i)
  end

  bottle do
    manifest_sha256 "ae5935feb4853f86353d43d4ec74cf634cffcc9ca19afb98946e088ff47098fc"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3693c776b73420fe86e2379b57bd1d78bc4e3812863da47c63987502e3614fae"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7858ee62a74976dfe2baac2d9faa434137d66f02cee87cecdad19637bb5478be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d180f74e61b243f5e5a87744c1114df2bb4d40c99347b0ca89d114989eb8e409"
    sha256 cellar: :any,                 arm64_linux:       "2a6286b14a8356bb4e344981463c7ad2ad877fdf70141f5348db47417a4c1f98"
    sha256 cellar: :any,                 x86_64_linux:      "c1cdb9573a336d3e3c9d4b4c9417fe335fbabc1532cea7b6b5cf0b33ccb559c7"
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
