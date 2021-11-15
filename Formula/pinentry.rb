class Pinentry < Formula
  desc "Passphrase entry dialog utilizing the Assuan protocol"
  homepage "https://www.gnupg.org/related_software/pinentry/"
  url "https://www.gnupg.org/ftp/gcrypt/pinentry/pinentry-1.2.0.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/pinentry/pinentry-1.2.0.tar.bz2"
  sha256 "10072045a3e043d0581f91cd5676fcac7ffee957a16636adedaa4f583a616470"
  license "GPL-2.0-only"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/pinentry/"
    regex(/href=.*?pinentry[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e4d3915028ad03c6b36c388ec9241daa297832023e7dae519971a737455b6872"
    sha256 cellar: :any,                 arm64_big_sur:  "f1aac9f10ce7c1cef39dd12298c1cf30f0534268084f19d63d3a9cf0e97f8205"
    sha256 cellar: :any,                 monterey:       "01fe87dba48bc028e2f461d1bd8e59c67b6fdc82775bb6aa000d080fc017732e"
    sha256 cellar: :any,                 big_sur:        "be92fdf84939d67ce31943821756e5d64b20b0b9056e31067a5fd0e96b20c2a1"
    sha256 cellar: :any,                 catalina:       "f77593c55d085e67e32b2a164830aec2ed4023a4114cbf642772b766fe530860"
    sha256 cellar: :any,                 mojave:         "6ca3c6242384a4e3a42cb88a2c88a932f4dbcf8b10ecdeb15afbaee0dd865f4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e257b1ff3aada1bdb7f78fba93d6ab8f445d880395cbc330f2d2277c91ad822c"
  end

  depends_on "pkg-config" => :build
  depends_on "libassuan"
  depends_on "libgpg-error"

  on_linux do
    depends_on "libsecret"
  end

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
