class Prips < Formula
  desc "Print the IP addresses in a given range"
  homepage "https://devel.ringlet.net/sysutils/prips/"
  url "https://devel.ringlet.net/files/sys/prips/prips-1.2.0.tar.xz"
  sha256 "de28d8a5a619a30d0b3c8a76f9c09c3529d197f3e74b04c8aa994096ab8349d4"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/current version .*?prips.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c4217811128ab612a4433b630d1a3d2c9e4805e1c163bfa22eeec7d03e095b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50a8faf4130d6ad1b281078e788aa0bdd8a34b32fda4f9dbde6247f0dcdbcfdf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "255619fe70f19aa2f4ce8616a48bcc96892678ddba5c2b40ba0191bee5dfe28d"
    sha256 cellar: :any_skip_relocation, ventura:        "ab6328571f6d30d60848ab91a95fbc3c2f4da337dc8f80ba91a7e43feb80512f"
    sha256 cellar: :any_skip_relocation, monterey:       "97c8079a862f2f3957c23762eb50034de5b6317c67696a18c5a6792da2b9cfb2"
    sha256 cellar: :any_skip_relocation, big_sur:        "32e889ecb796175e17ad03eb59ae8e7fea9ca015e228ef2369cbc21db55a7d0e"
    sha256 cellar: :any_skip_relocation, catalina:       "76f6e8fcbc1f60861023f6e035b04bec61d57fefb3bbfb87fbdeeafb47b68456"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2453199b92afe7e105fd95f698b5c9c7d6897f1d95d624b07c32bbfc65d44d0a"
  end

  def install
    system "make"
    bin.install "prips"
    man1.install "prips.1"
  end

  test do
    assert_equal "127.0.0.0\n127.0.0.1",
      shell_output("#{bin}/prips 127.0.0.0/31").strip
  end
end
