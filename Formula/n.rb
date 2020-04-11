class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v6.5.1.tar.gz"
  sha256 "5833f15893b9951a9ed59487e87b6c181d96b83a525846255872c4f92f0d25dd"
  head "https://github.com/tj/n.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "22ec6a5836ebdd491cd8bfbf1b1f2d0b55c29305dc665af799aeb109ddb99b45" => :catalina
    sha256 "22ec6a5836ebdd491cd8bfbf1b1f2d0b55c29305dc665af799aeb109ddb99b45" => :mojave
    sha256 "22ec6a5836ebdd491cd8bfbf1b1f2d0b55c29305dc665af799aeb109ddb99b45" => :high_sierra
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
