class Gloox < Formula
  desc "C++ Jabber/XMPP library that handles the low-level protocol"
  homepage "https://camaya.net/gloox/"
  url "https://camaya.net/download/gloox-1.0.22.tar.bz2"
  sha256 "4ade1b14848ccfcd89a505a4fff05116c24f13cef8d02fab0ade2717117ec964"
  revision 1

  bottle do
    cellar :any
    sha256 "b443d6fa0056204e7f7584c0e945eb231f1f1e2f19dea9d959f6ccf31cb190da" => :mojave
    sha256 "12c47414e056dbec998397a7b362d289aaa0966323fb90cf6cddc1ccb04d0b57" => :high_sierra
    sha256 "fbfbaf14b2af0b0c04d1fbd9961981dc4cc8777cb283cf63490838295712b693" => :sierra
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
