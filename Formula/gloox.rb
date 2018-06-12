class Gloox < Formula
  desc "C++ Jabber/XMPP library that handles the low-level protocol"
  homepage "https://camaya.net/gloox/"
  url "https://camaya.net/download/gloox-1.0.21.tar.bz2"
  sha256 "3c13155c10e3182a1a57779134cc524efb3657545849534b2831fae0e2c3a7cc"

  bottle do
    cellar :any
    sha256 "4a324d50d5f5ff5134bfd566e15dd9c524497040cec3be708e03e53a28078da9" => :high_sierra
    sha256 "cce3218f782cecbdf0b15920b286ca061c1181a5e42d1142edc32cfeaea28d1e" => :sierra
    sha256 "33c7be3f8548270a223ba01bf0e8c4ff19795af369d5470fd06f14093a5bc81e" => :el_capitan
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
