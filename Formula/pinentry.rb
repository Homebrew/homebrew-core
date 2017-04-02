class Pinentry < Formula
  desc "Passphrase entry dialog utilizing the Assuan protocol"
  homepage "https://www.gnupg.org/related_software/pinentry/"
  url "https://www.gnupg.org/ftp/gcrypt/pinentry/pinentry-1.0.0.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/pinentry/pinentry-1.0.0.tar.bz2"
  sha256 "1672c2edc1feb036075b187c0773787b2afd0544f55025c645a71b4c2f79275a"

  bottle do
    cellar :any
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
    ]

    args << "--disable-pinentry-gtk2" if build.without? "gtk+"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/pinentry", "--version"
  end
end
