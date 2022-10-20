class Astyle < Formula
  desc "Source code beautifier for C, C++, C#, and Java"
  homepage "https://astyle.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/astyle/astyle/astyle%203.1/astyle_3.1_linux.tar.gz"
  sha256 "cbcc4cf996294534bb56f025d6f199ebfde81aa4c271ccbd5ee1c1a3192745d7"
  license "MIT"
  head "https://svn.code.sf.net/p/astyle/code/trunk/AStyle"

  livecheck do
    url :stable
    regex(%r{url=.*?/astyle[._-]v?(\d+(?:\.\d+)+)_}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7db1ad4d3520edb8177939efd807958cb7687a147d29eb7fdd0edbd93f785ed6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1cc43739c9ff8b7e21f03935eacbc29a0656d42d4b52e662ed0079751efe84f"
    sha256 cellar: :any_skip_relocation, monterey:       "770266207c36b178c5070470e62c70d1e0f3ad20abd52cee4b1ce7a92ac3ab10"
    sha256 cellar: :any_skip_relocation, big_sur:        "a327f191b54d199962e6de529a18dd99a6ff5fea0afb30db813fd66da80ed358"
    sha256 cellar: :any_skip_relocation, catalina:       "bb1c58888bd7c8de8876e9a9aa27985d30e4c2a5c420ebaaf237fe3ee13c2900"
    sha256 cellar: :any_skip_relocation, mojave:         "7df95dd20d813717a1de8d5696d93eaaa8977d713738c2c83c16b7ba0f4eb1c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "280458c2e6508194d0f355cbc7b88e6c0a272a0b43caba8da9519e3c028f314e"
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
