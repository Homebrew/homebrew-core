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
    sha256 arm64_ventura:  "1955fb0ad761875d609cce71140d83b0b313d0b8e09f7a4d10de021aa04a474a"
    sha256 arm64_monterey: "9cfc7363abb102b284578c13d0e9b99a786bcd262e159541eebf6283c21c66c5"
    sha256 arm64_big_sur:  "c023005814ffc801b659d5819ce7dc3aef4906fa538b90ad5526bfbc5fdd8a98"
    sha256 ventura:        "13b643a6d383301f0df8dc7904398cda155d4417a4092adb6880881d6f21f981"
    sha256 monterey:       "ffd831497a499fd7af47d69ab535a2eea51fcc85cea1db07ca748da77f64272c"
    sha256 big_sur:        "bbc14e9b5e8e37b7ce5a498439097d4c3fe33c9126f9266f5c3089ec674c002c"
    sha256 catalina:       "80e9fc05b831780e67221d972957088c15b644d83f685ffed9db22d4587f27c2"
    sha256 x86_64_linux:   "d7d28c36ed2465543dd68313819bb940dcf0d0b5592af36199294801cc458681"
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
