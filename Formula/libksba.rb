class Libksba < Formula
  desc "X.509 and CMS library"
  homepage "https://www.gnupg.org/related_software/libksba/"
  url "https://gnupg.org/ftp/gcrypt/libksba/libksba-1.3.4.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/libksba/libksba-1.3.4.tar.bz2"
  sha256 "f6c2883cebec5608692d8730843d87f237c0964d923bbe7aa89c05f20558ad4f"
  revision 1

  bottle do
    cellar :any
    sha256 "3749554e37d40462d49cbb604cf07c2ed16165fe9ff54c55cd025e748f9907fc" => :el_capitan
    sha256 "5f1a4115836df7c235cc8961eec1d07a7c9142368bf2e46b99a3fb5d7d65e2ee" => :yosemite
    sha256 "52bdf9b140ebfcc20291056e1a6c38c88987d518c41c5ac857e212751be598d0" => :mavericks
  end

  depends_on "libgpg-error"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"ksba-config", prefix, opt_prefix
  end

  test do
    system "#{bin}/ksba-config", "--libs"
  end
end
