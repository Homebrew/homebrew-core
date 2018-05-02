class LibgpgError < Formula
  desc "Common error values for all GnuPG components"
  homepage "https://www.gnupg.org/related_software/libgpg-error/"
  url "https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.31.tar.bz2"
  sha256 "40d0a823c9329478063903192a1f82496083b277265904878f4bc09e0db7a4ef"

  bottle do
    sha256 "ed686be3df9cbfd8dc356563e7cf58cdecac6a8d8fb6c19b00c2505c0e39a9e1" => :high_sierra
    sha256 "c40335bfc1a9dec45ef555455e8a121c7ea14554bb838bb081186dfe3d953e2c" => :sierra
    sha256 "b8fe61b282c9d27506be5106ef4b1b175ed446511d555e05a56432c7f0c1e4f9" => :el_capitan
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
