class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v7.1.0.tar.gz"
  sha256 "20100f3bc56648cc414717fb7367fcf0e8229dc59a10b0530ccac90042ee0a74"
  license "MIT"
  head "https://github.com/tj/n.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "29bf84b0d1e37be5e65027bb4b974c176635283914504c582d8c53f5c56c5057"
    sha256 cellar: :any_skip_relocation, big_sur:       "90175d3f4e936cb6998c920511123e1891b22e3fe2e50c7334d5fc8dede0889f"
    sha256 cellar: :any_skip_relocation, catalina:      "d34c780c14bb6af59d9a432edf1ba7601892e36dfdeaff5f607de2334789e616"
    sha256 cellar: :any_skip_relocation, mojave:        "0ac4d878cfbdccb1592e84199a1145d16569564bb74917683ec306dee4d26f83"
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
