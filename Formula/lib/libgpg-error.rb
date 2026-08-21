class LibgpgError < Formula
  desc "Common error values for all GnuPG components"
  homepage "https://www.gnupg.org/related_software/libgpg-error/"
  url "https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.61.tar.bz2"
  sha256 "7a85413f2bc354f4f8aa832b718af122e48965e9e0eb9012ee659c13c6385c93"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libgpg-error/"
    regex(/href=.*?libgpg-error[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "74ecfae7911e36e85f9400931acab43770544c7826a3e7a8176c6410dfc10735"
    sha256 arm64_sequoia: "d209486b1890cf8194a71c00d976bdb4708ff82336232e4b7b38c64f7686de6d"
    sha256 arm64_sonoma:  "0aafdbae2cf7b4b2ad2abe85aeac0c9c6556dd49ef3e370477f5fc1d2fde5181"
    sha256 sonoma:        "928ced4a76a09b0431a5ea495945b391e9bf7d0e1ce9d2ce875737d73e74de92"
    sha256 arm64_linux:   "01f0d8da7da69748c319be0dafdb2adedd7eadfb22ae7aa7031bc92dfe4494a3"
    sha256 x86_64_linux:  "17c06341c6fc696e36e41d204129ea1e30e90951807194694d146bd16263af6b"
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
