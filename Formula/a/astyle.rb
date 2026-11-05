class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.6/astyle-3.6.22.tar.bz2"
  sha256 "dac3386e1bfbc76cc4e8c54915287670d744c075243fc8cfd37e8616386a525c"
  license "MIT"
  compatibility_version 1
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  livecheck do
    url :stable
    regex(%r{url=.*?/astyle[._-]v?(\d+(?:\.\d+)+)(?:[._-]linux)?\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e6e57fda939fe6fd3b35489d9ed5857768cbd751020d645d5c33b5d0d953c825"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "839ec727e2926f9ed12c45482fd8cd502de2ffbbd44e839443acd58c6040f941"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a398bb92d2128aba405433d8cf068382b431314c6300d3c24e6e7dcdd16f1870"
    sha256 cellar: :any,                 arm64_linux:       "235a0ac0c812c995a37fd9d0a9cc2e8e54d3da3ec8a970fa2c539cf888ac5571"
    sha256 cellar: :any,                 x86_64_linux:      "9d3884fa1faf341274a2d2c4e8c4ce8265d6d61c03445f8ab67a196ba3341381"
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
