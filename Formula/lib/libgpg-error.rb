class LibgpgError < Formula
  desc "Common error values for all GnuPG components"
  homepage "https://www.gnupg.org/related_software/libgpg-error/"
  url "https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.59.tar.bz2"
  sha256 "a19bc5087fd97026d93cb4b45d51638d1a25202a5e1fbc3905799f424cfa6134"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libgpg-error/"
    regex(/href=.*?libgpg-error[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "755e4e1aee069c7352e12e1d343fee26efbc805f4592941300de2ea3b9c0baa7"
    sha256 arm64_sequoia: "9d4c4ca00463b61a3d2229a5334e323a2897e83077d2112802d700b8e2b2f4af"
    sha256 arm64_sonoma:  "ccf4a15cc557216b7fab52ba4c0760d7d80904ca353ded597a2d60ff1686f39c"
    sha256 sonoma:        "4ea60f17b51fbd0ced9664250070a4676a2b87e6f9390197106cd1c299958420"
    sha256 arm64_linux:   "1c941ca9f52a119095cf7b07fa119798c05d1712c28c797527b958ec3daae0fa"
    sha256 x86_64_linux:  "8944d7d755ec39de4a4a052971cf5f8246189f0e3e3c6e2a172ab274925a89ec"
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
