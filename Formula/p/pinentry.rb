class Pinentry < Formula
  desc "Passphrase entry dialog utilizing the Assuan protocol"
  homepage "https://www.gnupg.org/related_software/pinentry/"
  url "https://www.gnupg.org/ftp/gcrypt/pinentry/pinentry-1.3.1.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/pinentry/pinentry-1.3.1.tar.bz2"
  sha256 "bc72ee27c7239007ab1896c3c2fae53b076e2c9bd2483dc2769a16902bce8c04"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/pinentry/"
    regex(/href=.*?pinentry[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "1d5fc3eb19d7e41caa4a8b61530e7040d0f3fbffb812ca24e116d6b247a0dadc"
    sha256 cellar: :any,                 arm64_sonoma:   "d657fb607715d8f374bb50e79be0a1bb129bf1f0cfb0f706dc0688d10058ee89"
    sha256 cellar: :any,                 arm64_ventura:  "5dc139b14332cfb907a8179e28d36a501266686699ce387f48452b060a21ebb3"
    sha256 cellar: :any,                 arm64_monterey: "829c5388c7fc1c40eaeba29199ae97ebd727bc2df2f143f1a6818f07b79dff12"
    sha256 cellar: :any,                 sonoma:         "6eb6f95ae8513f179cb658043457e39dbed3b95bbf1a7bb8aece3158d2fd4299"
    sha256 cellar: :any,                 ventura:        "1a750d73932b1c874887b38e186ad2017a36f230f3306983575bfa8b35c25e0d"
    sha256 cellar: :any,                 monterey:       "4bed735f12804f39955128939408210a31a8d0fd0b7d61f309779daa66053692"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ccf9f241e021929831e1da0c43206b87f99d1886d46e77ea8294f671ceb06c4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3e303a0b8099dedac66bbc95a0fdc3cfda679e594e60972d99eb3025c6f79fb"
  end

  depends_on "pkgconf" => :build
  depends_on "libassuan"
  depends_on "libgpg-error"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "glib"
    depends_on "libsecret"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    args = %w[
      --disable-silent-rules
      --disable-pinentry-fltk
      --disable-pinentry-gnome3
      --disable-pinentry-gtk2
      --disable-pinentry-qt
      --disable-pinentry-qt5
      --disable-pinentry-tqt
      --enable-pinentry-tty
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"pinentry", "--version"
    system bin/"pinentry-tty", "--version"
  end
end
