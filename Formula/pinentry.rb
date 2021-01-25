class Pinentry < Formula
  desc "Passphrase entry dialog utilizing the Assuan protocol"
  homepage "https://www.gnupg.org/related_software/pinentry/"
  url "https://www.gnupg.org/ftp/gcrypt/pinentry/pinentry-1.1.1.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/pinentry/pinentry-1.1.1.tar.bz2"
  sha256 "cd12a064013ed18e2ee8475e669b9f58db1b225a0144debdb85a68cecddba57f"
  license "GPL-2.0-only"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/pinentry/"
    regex(/href=.*?pinentry[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "b2fca70261e4f8a945628d62d8d673ee75df71bffa469616447928ab05eaa9bb" => :big_sur
    sha256 "933ed357a058e743d86ad965ecd246e8a228cc9b9fb05e310eb19c552f587201" => :arm64_big_sur
    sha256 "83a923d3334fa79364af9539de6126014209b8f50a313b7a085986d06fe80753" => :catalina
    sha256 "92cf647e09770cda92dd77ef0814da6ea8b69a27710e73fc4bf601e0d9d8a8ce" => :mojave
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
