class Ncftp < Formula
  desc "FTP client with an advanced user interface"
  homepage "https://www.ncftp.com/"
  url "ftp://ftp.ncftp.com/ncftp/ncftp-3.2.6-src.tar.gz"
  mirror "https://fossies.org/linux/misc/ncftp-3.2.6-src.tar.gz"
  sha256 "129e5954850290da98af012559e6743de193de0012e972ff939df9b604f81c23"

  bottle do
    sha256 "4082ca1bf2427d1780e0ebcf96b1d90d78630544a318ef94808ba003bfb49f47" => :catalina
    sha256 "3f7f108352b84b36c6d2174e4cc71c9b5b3632ac79b2aa8293205ea322541ba0" => :mojave
    sha256 "bd53fba3c13ba333f8e22ce0adc67a9ee3fa0d95e571f9833f4928d0adb0ee30" => :high_sierra
    sha256 "25caf7d9c7ac3c1642d3d205fcedfbea05878798033c0ff82cc3b5fbab4674d5" => :sierra
    sha256 "821f66bcd8991168314bb77f1404b3af6f93fda5c4fdcb3c651d3b7fbdd7f4fe" => :el_capitan
    sha256 "ac12f87bb648eb4dde883ad5ccca0c8cf80c60e1437ce03e5fc8d768fcec1bde" => :yosemite
  end

  def install
    system "./configure", "--disable-universal",
                          "--disable-precomp",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/ncftp", "-F"
  end
end
