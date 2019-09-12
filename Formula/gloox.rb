class Gloox < Formula
  desc "C++ Jabber/XMPP library that handles the low-level protocol"
  homepage "https://camaya.net/gloox/"
  url "https://camaya.net/download/gloox-1.0.22.tar.bz2"
  sha256 "4ade1b14848ccfcd89a505a4fff05116c24f13cef8d02fab0ade2717117ec964"
  revision 1

  bottle do
    cellar :any
    sha256 "4d7f5c002dc74b477a069fae22b7361371fa692a378a4186a508a92ecf24e7ad" => :mojave
    sha256 "53776432ab6f6637983b846f853a922fbe71e2d370f58457dc35eab30f3737bc" => :high_sierra
    sha256 "906216cebdc6ae1bf7e5f1a6eae8ae60fd5747f6832288a652f68a480d6dd42d" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libidn"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-zlib",
                          "--disable-debug",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "install"
  end

  test do
    system bin/"gloox-config", "--cflags", "--libs", "--version"
  end
end
