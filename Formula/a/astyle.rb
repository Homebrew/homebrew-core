class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.6/astyle-3.6.25.tar.bz2"
  sha256 "eb3d5d799cd204183896800b2186aa87131eb144c0e8df7a5e00c5efe4def037"
  license "MIT"
  compatibility_version 1
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  livecheck do
    url :stable
    regex(%r{url=.*?/astyle[._-]v?(\d+(?:\.\d+)+)(?:[._-]linux)?\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "874975c952c2e66ee04ddfd8d1c49976f9f338a0b759652ab82e1941a6b84a1a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "47118d9a35f78035f16c13c620945dd6930ad0e78a8835b78dd32cd9be6bc1b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4601955f1483ea3923576bc2b0290df6a93fb8712d5bbd38238eac103eb1f9d2"
    sha256 cellar: :any,                 arm64_linux:       "d94e5992422bed8b9780837ad9d2faa6775305aae2370a1d059d721b358195ef"
    sha256 cellar: :any,                 x86_64_linux:      "31455e1cae5b9f3512154e6c9b21a3f80c29f052a253fa7a050602061ead1220"
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
