class Less < Formula
  desc "Pager program similar to more"
  homepage "http://www.greenwoodsoftware.com/less/index.html"
  url "https://ftp.gnu.org/gnu/less/less-530.tar.gz"
  mirror "https://ftpmirror.gnu.org/less/less-530.tar.gz"
  sha256 "503f91ab0af4846f34f0444ab71c4b286123f0044a4964f1ae781486c617f2e2"
  revision 1

  bottle do
    sha256 "6e0881558623d909107e5ebfab32772d164a772863b54cebec8144352ce66ccf" => :mojave
    sha256 "edec3486e523a601dfe978a8a9524c8cef7a161c8e892d3154cd578623e866a7" => :high_sierra
    sha256 "10c47d26e0f2e1f9c2e46a6bd61b2d07e1104caaa58c188b4b81b7fe0cd948d1" => :sierra
    sha256 "0e98c6e82ecf7adb2d5288f3f4913ffa238469438b325211adf56eff9b260876" => :el_capitan
  end

  depends_on "pcre"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-regex=pcre"
    system "make", "install"
  end

  test do
    system "#{bin}/lesskey", "-V"
  end
end
