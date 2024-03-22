class LibgpgError < Formula
  desc "Common error values for all GnuPG components"
  homepage "https://www.gnupg.org/related_software/libgpg-error/"
  url "https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.48.tar.bz2"
  sha256 "89ce1ae893e122924b858de84dc4f67aae29ffa610ebf668d5aa539045663d6f"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libgpg-error/"
    regex(/href=.*?libgpg-error[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "a0ba26a324b2b0ecd2346f1c1075a7cec1b73029ae92321b2271de1a254ceb42"
    sha256 arm64_ventura:  "84627e30a47510d90f048ce09b41a4c85950444d93f59b586cbfa12b86663670"
    sha256 arm64_monterey: "46968ed0dc58494cfbd33ebea402c0ad15d8515aa9d6b49655e32a513889c4d8"
    sha256 sonoma:         "5fbd068a04c0aba00404f7b69c5fb2b0bed32eb31eff35981583968dba072485"
    sha256 ventura:        "9333a88dbebd98b41a07f3d68fc23099c686a53498a86cc74355f74ee7b6eb8f"
    sha256 monterey:       "e1a2e37e62d528b0d512524248d8682180947eb043437f37b99af9a361c829dd"
    sha256 x86_64_linux:   "5669f61dcc25f047eab9eadd84fe279af4cba2eff2e726043d84ee1fdf3a53e7"
  end

  on_macos do
    depends_on "gettext"
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
