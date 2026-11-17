class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.6/astyle-3.6.26.tar.bz2"
  sha256 "3f0543297c24a5d53b5b7447e7ef674804b41c67171b8b7ebb3e3c4d203e30b7"
  license "MIT"
  compatibility_version 1
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  livecheck do
    url :stable
    regex(%r{url=.*?/astyle[._-]v?(\d+(?:\.\d+)+)(?:[._-]linux)?\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c1b543215f8a9493dab72f25cd494742af0e7c9a490069975eec3d0e6977062a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1f19f355b19e2226c753efe40662056cb1fa88fcce424f661b098ec299c0c73f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "52c4be4b218c1da5902f69de1e98b6021d3ca6ae8c51dd0c6e70ed39c1b17038"
    sha256 cellar: :any,                 arm64_linux:       "5470dbdaf960b302a2408e98b1e6361c232f7642480a88c87fdf0cc86f92ade6"
    sha256 cellar: :any,                 x86_64_linux:      "2b72329d40733634a27c82300e3f09730c5856036d3fbb4dce8d3cde93b450f8"
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
