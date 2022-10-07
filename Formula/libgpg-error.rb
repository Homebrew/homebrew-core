class LibgpgError < Formula
  desc "Common error values for all GnuPG components"
  homepage "https://www.gnupg.org/related_software/libgpg-error/"
  url "https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.46.tar.bz2"
  sha256 "b7e11a64246bbe5ef37748de43b245abd72cfcd53c9ae5e7fc5ca59f1c81268d"
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
    # NOTE: gpg-error-config is deprecated upstream, so we should remove this at some point.
    # https://dev.gnupg.org/T5683
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--enable-install-gpg-error-config",
                          "--enable-static"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace [bin/"gpg-error-config", lib/"pkgconfig/gpg-error.pc"], prefix, opt_prefix
  end

  test do
    system bin/"gpgrt-config", "--libs"
  end
end
