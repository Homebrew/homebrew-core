class LibgpgError < Formula
  desc "Common error values for all GnuPG components"
  homepage "https://www.gnupg.org/related_software/libgpg-error/"
  url "https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.42.tar.bz2"
  sha256 "fc07e70f6c615f8c4f590a8e37a9b8dd2e2ca1e9408f8e60459c67452b925e23"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libgpg-error/"
    regex(/href=.*?libgpg-error[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "72d70667728d9b1bfe4071913c800db2baa55af9fc603dbd96b2fcd477d828b0"
    sha256 big_sur:       "453688272ae89f5f4b5a852ec1c2c31d3c2410abb95ca5039f5a0d4edfc4b64b"
    sha256 catalina:      "bb8090fbf1399ed80904df570978a16b72af1b300c17f68493b602606e90d516"
    sha256 mojave:        "ef3446809a6b3d9da0f5d4a45b9d2c21a7bf4549d14cc785843f4f969f13ea39"
    sha256 x86_64_linux:  "b862b10316313dabc9ddc7774e37c41c0700b886d361b86a1485052287b73fd0"
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
