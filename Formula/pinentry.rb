class Pinentry < Formula
  desc "Passphrase entry dialog utilizing the Assuan protocol"
  homepage "https://www.gnupg.org/related_software/pinentry/"
  url "https://www.gnupg.org/ftp/gcrypt/pinentry/pinentry-1.1.0.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/pinentry/pinentry-1.1.0.tar.bz2"
  sha256 "68076686fa724a290ea49cdf0d1c0c1500907d1b759a3bcbfbec0293e8f56570"

  bottle do
    cellar :any
    sha256 "f7cb947bae3b5bd9bb6243a8882631c5baa97008a964235e36d056797cb0cd25" => :high_sierra
    sha256 "6ce2fe92d8e0cf8984ec00c1332bceb33579eee5ce005355e26c567a15a2d4d0" => :sierra
    sha256 "dd3bc57a5eeaedc8ef075eedfbd2a7ce62983318b4f191c728e250720f785556" => :el_capitan
    sha256 "edd1bc6682280c4d2d5bdaf63e4592e3921c63cd4c87af075ca937327ae7ff48" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libgpg-error"
  depends_on "libassuan"
  depends_on "gtk+" => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --disable-pinentry-qt
      --disable-pinentry-qt5
      --disable-pinentry-gnome3
      --disable-pinentry-tqt
      --disable-pinentry-fltk
    ]

    args << "--disable-pinentry-gtk2" if build.without? "gtk+"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/pinentry", "--version"
  end
end
