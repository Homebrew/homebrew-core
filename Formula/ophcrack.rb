class Ophcrack < Formula
  desc "Microsoft Windows password cracker using rainbow tables"
  homepage "https://ophcrack.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ophcrack/ophcrack/3.8.0/ophcrack-3.8.0.tar.bz2"
  mirror "https://deb.debian.org/debian/pool/main/o/ophcrack/ophcrack_3.8.0.orig.tar.bz2"
  sha256 "048a6df57983a3a5a31ac7c4ec12df16aa49e652a29676d93d4ef959d50aeee0"
  revision 1

  bottle do
    cellar :any
    sha256 "47361d9c18591930ce871fa3c7ab36eaa43003a8a5339238648787cdd748d962" => :catalina
    sha256 "0bdbfbee37e693edff5fc8f71c52f1fb12d6dd07c1e64aa1a20401df0789853a" => :mojave
    sha256 "a1061331c1e9b4a726c818005a3d795ba8c73b29ecd78a3828b5e5eafac18107" => :high_sierra
    sha256 "6229ee0c1e44192fa0d513b7e72e5c72e7fbd29b5ad7f61cd5c5824d76d49105" => :sierra
  end

  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-debug",
                          "--disable-gui",
                          "--with-libssl=#{Formula["openssl@1.1"].opt_prefix}",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"ophcrack", "-h"
  end
end
