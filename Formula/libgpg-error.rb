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
    sha256 arm64_monterey: "05732e309a8283f14730e29b92d8c3a3c9db79de397f427414ad42351d208ed8"
    sha256 arm64_big_sur:  "4049a428bcc5566af7a0dce0f8c04ff469b68e9f855d18f8f9a0e62ddfbde7f3"
    sha256 monterey:       "be35f71d00903ecfa28e902ad57e5a95383ba5d1922c3b0e1626ebc28b58153f"
    sha256 big_sur:        "371011245238dfdd29b8cb8f5b14798e2a2a3ba69dccc89590802d59cd75a2ae"
    sha256 catalina:       "9bd703503504029a4bdb9655cf9abab773cda6a9b3f1c7ede9c88ed51b7ea933"
    sha256 x86_64_linux:   "5d697f03c8f58ecad98069dc70798788df756aa242f1aeb5fbd72b966384e51d"
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
