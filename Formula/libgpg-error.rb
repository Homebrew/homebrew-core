class LibgpgError < Formula
  desc "Common error values for all GnuPG components"
  homepage "https://www.gnupg.org/related_software/libgpg-error/"
  url "https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.27.tar.bz2"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/libg/libgpg-error/libgpg-error_1.27.orig.tar.bz2"
  sha256 "4f93aac6fecb7da2b92871bb9ee33032be6a87b174f54abf8ddf0911a22d29d2"

  bottle do
    sha256 "7ffa1c12c9a452f2292cb6a171b4e88136c631cee4da67d71143529bf3352a93" => :sierra
    sha256 "a81e55fecb35b921df543e8cf83729a8695d745fa778f716d4c96f989aceb6b4" => :el_capitan
    sha256 "06669414f7aba892558875994c411dc2a0723aa19f5d854b435987b3c8b9f19a" => :yosemite
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
