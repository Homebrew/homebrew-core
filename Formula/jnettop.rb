class Jnettop < Formula
  desc "View hosts/ports taking up the most network traffic"
  homepage "https://web.archive.org/web/20161127214942/jnettop.kubs.info/wiki/"
  url "https://downloads.sourceforge.net/project/jnettop/jnettop/0.13/jnettop-0.13.0.tar.gz"
  sha256 "a005d6fa775a85ff9ee91386e25505d8bdd93bc65033f1928327c98f5e099a62"
  revision 1

  bottle do
    cellar :any
    sha256 "a98f66b183e2eadaea198bf62ceb8da42c044943152617089aa942b5bf9b55b5" => :mojave
    sha256 "080fb7eb6cdc86c32d899a99acef5f509c35204b794bd920f19c31ed5887727a" => :high_sierra
    sha256 "90ebc909ac301d2ec5c9595581c796a15200e0f8439f353148bff0b214aafb26" => :sierra
    sha256 "d5e07a56ee0fc93972f31dc878558d9d4348a4a3dd4e9b06a8c858008541657b" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--man=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/jnettop", "-h"
  end
end
