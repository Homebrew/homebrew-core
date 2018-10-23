class Prips < Formula
  desc "Print the IP addresses in a given range"
  homepage "https://devel.ringlet.net/sysutils/prips/"
  url "https://devel.ringlet.net/files/sys/prips/prips-1.1.0.tar.xz"
  mirror "https://deb.debian.org/debian/pool/main/p/prips/prips_1.1.0.orig.tar.xz"
  sha256 "f6f85ee0234218e426cb72b27411902a55e1daa02f22d1e7270ff41e07fe0444"

  bottle do
    cellar :any_skip_relocation
    sha256 "32a6c4120f0af9eadf028e4095249a3056e998b37ebb9bacd6764e99615a82d1" => :mojave
    sha256 "0180f9d16dce43e8900e060cde301182e9370cf1b7bdb84d8c0acec2d2b5c5af" => :high_sierra
    sha256 "2bfab7fad1bead6d1a0e44df90fae171fd6676604bc5cee6c541b37205db694c" => :sierra
    sha256 "b07d7014555a9730e0bb7216db26ba2a52e0e04131ca8804fe7a3f0031517fce" => :el_capitan
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
