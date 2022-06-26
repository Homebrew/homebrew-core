class Ncompress < Formula
  desc "Fast, simple LZW file compressor"
  homepage "https://github.com/vapier/ncompress"
  url "https://github.com/vapier/ncompress/archive/v5.0.tar.gz"
  sha256 "96ec931d06ab827fccad377839bfb91955274568392ddecf809e443443aead46"
  license "Unlicense"
  head "https://github.com/vapier/ncompress.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9dbd83bf79e6dc3934b84e104305dc7772100aafe85a724275a821d3a4c68762"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ed0a835e287915e90e45a75971aefd707578cf96ddcbe631fd8bab34000af98"
    sha256 cellar: :any_skip_relocation, monterey:       "d209c387414dfd51d7f7bf079edce89699d6a60eb248bf48d90d1977dd3dbc4d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b78cd2bde25384f42fd1f5d29ec6b1a909449e6f20c20c44c232885d0d99acbe"
    sha256 cellar: :any_skip_relocation, catalina:       "55220d13762facae37b84f1b6fcc6ec696daee5cc8b8478b868f5f7e34123af2"
    sha256 cellar: :any_skip_relocation, mojave:         "e680253759776cc3de92aee1afac39c180f1758113bc56e25bbd469206df0c5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7cc0946635cd04b532b9c458ec215f1631d08dea366741346308d0030edfa05b"
  end

  keg_only :provided_by_macos

  def install
    system "make", "install", "BINDIR=#{bin}", "MANDIR=#{man1}"
  end

  test do
    Pathname.new("hello").write "Hello, world!"
    system "#{bin}/compress", "-f", "hello"
    assert_match "Hello, world!", shell_output("#{bin}/compress -cd hello.Z")
  end
end
