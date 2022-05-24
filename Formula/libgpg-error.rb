class LibgpgError < Formula
  desc "Common error values for all GnuPG components"
  homepage "https://www.gnupg.org/related_software/libgpg-error/"
  url "https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.45.tar.bz2"
  sha256 "570f8ee4fb4bff7b7495cff920c275002aea2147e9a1d220c068213267f80a26"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libgpg-error/"
    regex(/href=.*?libgpg-error[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "baa7d6da4145fa08ce672266c7a96d5720f18023d592e41c6065698442aa3d65"
    sha256 arm64_big_sur:  "3f2bc118d7ecc071fd0f8ca4fb61221bc61d4c3f5d7ba26eaafe0d1a5cfb2134"
    sha256 monterey:       "ddf3f208ffe114a1d3480d8f86236b828f75645eefe10bafdb4df2a93f60d460"
    sha256 big_sur:        "a0bd223501f42446427f4095c3cb37063edbef595b688b2e2ffbe8ace712cfbd"
    sha256 catalina:       "2c33af3d7fbd745eec203b1db66b2f7af89d3c3176623bec359733cffdec8729"
    sha256 x86_64_linux:   "d6bd857e7da84259447f1c19759cb12444e5e6ae364597c7f6081ca6b35b2f0b"
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
