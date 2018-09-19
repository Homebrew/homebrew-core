class Gloox < Formula
  desc "C++ Jabber/XMPP library that handles the low-level protocol"
  homepage "https://camaya.net/gloox/"
  url "https://camaya.net/download/gloox-1.0.21.tar.bz2"
  sha256 "3c13155c10e3182a1a57779134cc524efb3657545849534b2831fae0e2c3a7cc"
  revision 1

  bottle do
    cellar :any
    sha256 "76e08ce8f5e51168e8d3e3ad50b46ec0564c1f8c73b51a0a02369f528d1b366f" => :mojave
    sha256 "3f72253357c59741e8a2bee9898b526950394acf5c6482ae15fea664abc26368" => :high_sierra
    sha256 "f0812d2040520df39193a65c7edbca2b49092f409a495a7e74f7619a86f58597" => :sierra
    sha256 "f9e1d2ae48aa08d5c223aa4d85cf553205e400f9f68207f0107b5a752db01f22" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libidn"
  depends_on "openssl"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-zlib",
                          "--disable-debug",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  test do
    system bin/"gloox-config", "--cflags", "--libs", "--version"
  end
end
