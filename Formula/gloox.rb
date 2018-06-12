class Gloox < Formula
  desc "C++ Jabber/XMPP library that handles the low-level protocol"
  homepage "https://camaya.net/gloox/"
  url "https://camaya.net/download/gloox-1.0.21.tar.bz2"
  sha256 "3c13155c10e3182a1a57779134cc524efb3657545849534b2831fae0e2c3a7cc"

  bottle do
    cellar :any
    sha256 "d6acd544200f6524e6c6c4b4c12747e855abb0fb6129628e86166b921035dc39" => :high_sierra
    sha256 "8268b106a2de45233f339630793ebdb46c501925faa758f0d61eb7485ced1c87" => :sierra
    sha256 "7b0dafa8d25adac387410d0bd064c2645d4fb8826c0b24b840c71e3e783eaa3b" => :el_capitan
    sha256 "12fa240ab11bad334840099b0a8574b6cce0064647b06bb433f3600669bd6cda" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "libidn" => :optional

  # Fix expectation that <openssl/comp.h> will always be available.
  # Merged upstream; remove on next release.
  patch do
    url "https://mail.camaya.net/services/download/?app=whups&actionID=download_file&file=tlsopensslbase_comp_fix.diff&ticket=276&fn=%2Ftlsopensslbase_comp_fix.diff"
    sha256 "509e8121cbefbad57e380f9156a088ebfdc93ebf28a53bd8e2053c12326e2e12"
  end

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
