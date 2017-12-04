class Pinentry < Formula
  desc "Passphrase entry dialog utilizing the Assuan protocol"
  homepage "https://www.gnupg.org/related_software/pinentry/"
  url "https://www.gnupg.org/ftp/gcrypt/pinentry/pinentry-1.1.0.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/pinentry/pinentry-1.1.0.tar.bz2"
  sha256 "68076686fa724a290ea49cdf0d1c0c1500907d1b759a3bcbfbec0293e8f56570"

  bottle do
    cellar :any
    sha256 "13cf37ad9d68a82907593bd0b82a8ecee114381c081fa4a600f439ae0b696546" => :high_sierra
    sha256 "c2ec42c20d6919dea12322faf083db4724d2bfd269b8d435e80c6df0515a6bcc" => :sierra
    sha256 "e95489766f86c53062781a3be19506660b1265c690a904692b49edac3b6516dd" => :el_capitan
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
