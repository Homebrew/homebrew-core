class Gpa < Formula
  desc "Graphical user interface for the GnuPG"
  homepage "https://www.gnupg.org/related_software/gpa/"
  url "https://gnupg.org/ftp/gcrypt/gpa/gpa-0.11.1.tar.bz2"
  mirror "https://deb.debian.org/debian/pool/main/g/gpa/gpa_0.11.1.orig.tar.bz2"
  sha256 "0bc5b2cd3e0641d07a2d8af372a09659decd918bee22fdfbefd2133d7c4d5d0b"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gpa/"
    regex(/href=.*?gpa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "3a82b91a089610dccf3f303827932bc3392cd4024d0ff62efec8392f5930aeab"
    sha256 arm64_sequoia: "2a4266a3cbad43f2f54cadb15eb3ddb790b2d2db2780604df6b42b94bf9b1afa"
    sha256 arm64_sonoma:  "8af83db187a7f1f5e3754451774d829fa3d6e42ccc7c2e5e5a81f3188dd9fab1"
    sha256 sonoma:        "47b09b31877384921bc68ed46e530ab9ac5bab39be5ede50f74094033bd0ecb1"
    sha256 arm64_linux:   "2c38b595e2e3aa802f989d8b45feb610d783c0009433f8bdc28855fd3ed4765f"
    sha256 x86_64_linux:  "d92aa141bfd3900387f1862202f6f7e7bc8d958001b5db3c68251033a572140a"
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

  on_macos do
    depends_on "at-spi2-core"
    depends_on "cairo"
    depends_on "gettext"
    depends_on "harfbuzz"
    depends_on "pango"
  end

  on_linux do
    depends_on "zlib-ng-compat"
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
