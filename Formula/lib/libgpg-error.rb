class LibgpgError < Formula
  desc "Common error values for all GnuPG components"
  homepage "https://www.gnupg.org/related_software/libgpg-error/"
  url "https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.58.tar.bz2"
  sha256 "f943aea9a830a8bd938e5124b579efaece24a3225ff4c3d27611a80ce1260c27"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libgpg-error/"
    regex(/href=.*?libgpg-error[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "cfc442a456cfeee3f6ab78d77886d5cb1ed1ceb4745803ae34a577ff88ce73b5"
    sha256 arm64_sequoia: "48a54d998598a2ba0438ad5137a0865dc3aa7c2ad92a3632fef1ededd10f78b9"
    sha256 arm64_sonoma:  "935ca33a83b8bac590a5fdebaf40ad8deaec9c695477fcdf4b312404e439d5d7"
    sha256 sonoma:        "feb3618a54debc5fe2daabbc3c687dcd232ad5d31db06bd5e3001c45fad98426"
    sha256 arm64_linux:   "18dafe85f05a79d6e462f878edf6be9dadfab2cf494e94116ba0ab67332a817d"
    sha256 x86_64_linux:  "955668c906d66b7404c1adbd0e5b0e6aaf3db83fa9d21062891603f817f0a089"
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
