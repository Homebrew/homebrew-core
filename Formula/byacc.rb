class Byacc < Formula
  desc "(Arguably) the best yacc variant"
  homepage "http://invisible-island.net/byacc/byacc.html"
  url "ftp://invisible-island.net/byacc/byacc-20160606.tgz"
  sha256 "cc8fdced486cb70cec7a7c9358de836bfd267d19d6456760bb4721ccfea5ac91"

  bottle do
    cellar :any_skip_relocation
    sha256 "a18190ec0e6f99c00330e79221936bcec25d4e22ac97fdc95c59c519dacab1b5" => :sierra
    sha256 "24c0040a574e18dae038699475b58d66e15ccc3a478aa04d7993e2aa8ecc75d1" => :el_capitan
    sha256 "718d99ac1bf381aebfcd0d0c330780b1e72c3ff22d119387c81c9e8f2062ad2d" => :yosemite
    sha256 "0c559a496f3161e277996d685d047bec485479f507a83c824f7e945d371fa54a" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--program-prefix=b", "--prefix=#{prefix}", "--man=#{man}"
    system "make", "install"
  end

  test do
    system bin/"byacc", "-V"
  end
end
