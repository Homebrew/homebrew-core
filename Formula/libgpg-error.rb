class LibgpgError < Formula
  desc "Common error values for all GnuPG components"
  homepage "https://www.gnupg.org/related_software/libgpg-error/"
  url "https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.26.tar.bz2"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/libg/libgpg-error/libgpg-error_1.26.orig.tar.bz2"
  sha256 "4c4bcbc90116932e3acd37b37812d8653b1b189c1904985898e860af818aee69"

  bottle do
    sha256 "84ecae359a015fefe16831ddfe5d3dfc99772c8903ce711badd0376dfc9a3a0f" => :sierra
    sha256 "12ae29c509eb5ed2cd0c81ce0a5ac6378fb969703f62c195a059929df22105a9" => :el_capitan
    sha256 "c7ca03639e52db681ed04b799343e63c61996e5781286ef00c6cb5f6b7a18731" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"gpg-error-config", prefix, opt_prefix
  end

  test do
    system "#{bin}/gpg-error-config", "--libs"
  end
end
