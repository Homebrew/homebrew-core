class Gpa < Formula
  desc "Graphical user interface for the GnuPG"
  homepage "https://www.gnupg.org/related_software/gpa/"
  url "https://gnupg.org/ftp/gcrypt/gpa/gpa-0.11.0.tar.bz2"
  mirror "https://deb.debian.org/debian/pool/main/g/gpa/gpa_0.11.0.orig.tar.bz2"
  sha256 "26a8fa5bf70541cb741f0c71b7cfe291b1ea56eab68eeb07aa962cef5cdf33cc"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gpa/"
    regex(/href=.*?gpa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "c0c60b01b9d98ed8aab7c7527587a47d3da59296f9bc1fd4fd42de59ca7ddbb8"
    sha256 arm64_sonoma:  "df87078cf6cf9f08a8929ee7b17f8c02c59e861dc2b95dde4219ad1bb618ffa5"
    sha256 arm64_ventura: "aef02be2a1ff1789b39b13a9aeb992f205dad05cc86bb5b49c56bfcb8c574602"
    sha256 sonoma:        "3aebae31685d4eed01681ce32eb85166e4eabb1aa653b113295d9d22539b2f32"
    sha256 ventura:       "ba20f9563e8f329507ebae4de2101385737dc2853134c35b555b1a150e17f101"
    sha256 arm64_linux:   "9393bde60e35d9ed3b29536c4025744e2d4051c24287d0617b4aa861a5e8cc10"
    sha256 x86_64_linux:  "07d492d6e76e1bfab56580d855828fc133ea535bb83ef7ffa07cbeb31ad8269c"
  end

  head do
    url "https://dev.gnupg.org/source/gpa.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "desktop-file-utils" => :build
  depends_on "pkgconf" => :build

  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gpgme"
  depends_on "gtk+3"
  depends_on "libassuan"
  depends_on "libgpg-error"

  uses_from_macos "zlib"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "cairo"
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "pango"
  end

  def install
    inreplace "configure", "NEED_LIBASSUAN_API=2", "NEED_LIBASSUAN_API=3"

    ENV.append_to_cflags "-Wno-implicit-function-declaration"

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"gpa", "--version"
  end
end
