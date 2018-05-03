class LibgpgError < Formula
  desc "Common error values for all GnuPG components"
  homepage "https://www.gnupg.org/related_software/libgpg-error/"
  url "https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.31.tar.bz2"
  sha256 "40d0a823c9329478063903192a1f82496083b277265904878f4bc09e0db7a4ef"

  bottle do
    sha256 "91e1dee88df2e6c7e103feed2ffb40fa650ab8afa788a53d9c129058b2169ed4" => :high_sierra
    sha256 "bf4c3dcb54310d9496bb745a29983bd4b85ee65a4deac55c8eb776cb2ff03622" => :sierra
    sha256 "eee153a0942ba138b18515aff9fa4b67af95582dfbfd522766d23ddbf0a9da31" => :el_capitan
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
