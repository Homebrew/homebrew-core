class Pinentry < Formula
  desc "Passphrase entry dialog utilizing the Assuan protocol"
  homepage "https://www.gnupg.org/related_software/pinentry/"
  url "https://www.gnupg.org/ftp/gcrypt/pinentry/pinentry-1.1.0.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/pinentry/pinentry-1.1.0.tar.bz2"
  sha256 "68076686fa724a290ea49cdf0d1c0c1500907d1b759a3bcbfbec0293e8f56570"
  revision 1

  bottle do
    cellar :any
    sha256 "58dbcd3dc641fe0e14829d2d72be6bc5cadc9a5c26bf50678906866101d2589a" => :catalina
    sha256 "206708ea13875bc8197f7d066bc0cb36893bd95b9ecc7ba6102c2f33b0fbd6c4" => :mojave
    sha256 "a1a0e526f622d7dc4e2b3e0dcde061dbb383050b8efbe424d916bf983ae66c74" => :high_sierra
    sha256 "fd93c11a28d38ba1b78c7fe646f027f98ce29c08ba02c7a0e14e69f355614e35" => :sierra
    sha256 "e8c6180d9d86f008d0d9cdf0bc9638f2c119bb426504955ecbd16ef6b108d01d" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libassuan"
  depends_on "libgpg-error"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --disable-pinentry-fltk
      --disable-pinentry-gnome3
      --disable-pinentry-gtk2
      --disable-pinentry-qt
      --disable-pinentry-qt5
      --disable-pinentry-tqt
      --enable-pinentry-tty
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/pinentry", "--version"
    system "#{bin}/pinentry-tty", "--version"
  end
end
