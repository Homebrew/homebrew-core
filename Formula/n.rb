class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v2.1.12.tar.gz"
  sha256 "fdcd2f19cee7fdbe1e5584e06bd12106fbc283bbb41b2188acbddf3280068ea1"
  head "https://github.com/tj/n.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3d2d6d14656cc7cd2bed8ecb257c250fc5792a8173f3461175329ae0f94da8a5" => :mojave
    sha256 "cfa1403ccb97b99957c561703936de5cd14dda63493ecff2608c67c455e6551f" => :high_sierra
    sha256 "cfa1403ccb97b99957c561703936de5cd14dda63493ecff2608c67c455e6551f" => :sierra
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
