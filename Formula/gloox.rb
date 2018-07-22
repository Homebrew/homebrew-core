class Gloox < Formula
  desc "C++ Jabber/XMPP library that handles the low-level protocol"
  homepage "https://camaya.net/gloox/"
  url "https://camaya.net/download/gloox-1.0.21.tar.bz2"
  sha256 "3c13155c10e3182a1a57779134cc524efb3657545849534b2831fae0e2c3a7cc"

  bottle do
    cellar :any
    rebuild 1
    sha256 "d8377965f6bde00d603fe9ee86a4c7509baae004055c7b5e956a49428ecc85c9" => :high_sierra
    sha256 "7e7d052c6c26c7637607c464dd63819462a95dfbb3aa4efe59be9dd0f7ab55c1" => :sierra
    sha256 "3023d30363b888f46408b8d9d79c38e2a96cfeb4dd071edb26c262b78d532bb5" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "libidn" => :optional

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
