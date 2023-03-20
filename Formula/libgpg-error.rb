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
    rebuild 1
    sha256 arm64_ventura:  "f5a6db667584320df0aa91b6817a9fd910b96bcd101ab75ee3a5d86531e89e3d"
    sha256 arm64_monterey: "a299620e41577dcbfeb796ce39eae98e48942d89ea71d65008abf585ce3fcc3e"
    sha256 arm64_big_sur:  "e7479d41231a98176bd553b1f290d57edd7fc407c5b65d77d120ffc1af488796"
    sha256 ventura:        "98a660faf039772f82c82546f4112cb790f889e5921b7424b8ba512fdc62dd4f"
    sha256 monterey:       "d54bc062f430ef13c387f1569540954983792cc11a7dbd195870e48e1aba1a1d"
    sha256 big_sur:        "f2724515c0fc44a7b0c0c7743c406c5421bb7050615d583ac7502e5dabb7ae83"
    sha256 x86_64_linux:   "1bfe076ef9c724140487b4346566be5d0e1ff45599aa938c4d7f31abe21215b9"
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
