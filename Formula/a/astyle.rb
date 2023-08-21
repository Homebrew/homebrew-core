class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.4/astyle-3.4.tar.bz2"
  sha256 "2bac07a46197da962bf3fb8313373242e2190b7739e4203a703eb89b603aaa07"
  license "MIT"
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  livecheck do
    url :stable
    regex(%r{url=.*?/astyle[._-]v?(\d+(?:\.\d+)+)(?:[._-]linux)?\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a66b4114de4b1673fe52cd50645dc4e9ec9462e78098683b12ca1ae4b93d729"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4d11a1c40f9ac0becedca729d6d9ffa8da49536ac974fec78676fab85f53c99"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "296528ec43b0e09422d9f397904af74e02e87f3fe919ab992dacb5c64b2e4a66"
    sha256 cellar: :any_skip_relocation, ventura:        "0f60a1c72e95832aee6b0433772854dd01060e9184a2feb68982607c83c91ef0"
    sha256 cellar: :any_skip_relocation, monterey:       "84767ac6a2e7c8d3f3edb22aff50dda54cc362e070e1db67f7377d5ba4ecfb52"
    sha256 cellar: :any_skip_relocation, big_sur:        "833addcbf161e536f7579500ea51ce95d9cd5cd37c04646190ae1630c8f4bb33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d2854a24709d893ab6f3cb35763760ff39cb089964877df7591fdcf64138532"
  end

  def install
    cd "src" do
      system "make", "CXX=#{ENV.cxx}", "-f", "../build/gcc/Makefile"
      bin.install "bin/astyle"
    end
  end

  test do
    (testpath/"test.c").write("int main(){return 0;}\n")
    system "#{bin}/astyle", "--style=gnu", "--indent=spaces=4",
           "--lineend=linux", "#{testpath}/test.c"
    assert_equal File.read("test.c"), <<~EOS
      int main()
      {
          return 0;
      }
    EOS
  end
end
