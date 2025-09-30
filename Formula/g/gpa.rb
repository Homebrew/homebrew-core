class Gpa < Formula
  desc "Graphical user interface for the GnuPG"
  homepage "https://www.gnupg.org/related_software/gpa/"
  license "GPL-3.0-or-later"
  revision 1

  stable do
    url "https://gnupg.org/ftp/gcrypt/gpa/gpa-0.11.0.tar.bz2"
    mirror "https://deb.debian.org/debian/pool/main/g/gpa/gpa_0.11.0.orig.tar.bz2"
    sha256 "26a8fa5bf70541cb741f0c71b7cfe291b1ea56eab68eeb07aa962cef5cdf33cc"

    # Fix for `gpgme` >= 2.0.0 compatibility
    patch do
      url "https://git.gnupg.org/cgi-bin/gitweb.cgi?p=gpa.git;a=patch;h=b6ba8bcc6db7765667cd6c49b7edc9a2073bc74f"
      sha256 "3aab76d3d79cad0c756f9c73cc237b8632ae9e7f68d5f7715c3ca58e2c633bc5"
    end
  end

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gpa/"
    regex(/href=.*?gpa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "dadbb049d9885447f60ee0cfcada2faf0da3251d49182f8879a0bba60df16f18"
    sha256 arm64_sequoia: "69c538278add61a01e2a4cf2322c4fd36889105a1616c6a1121a42ef236046b8"
    sha256 arm64_sonoma:  "6d33523eedf82d824372a0aa44d7f645fba618b5962b353a19852a3af16826e2"
    sha256 arm64_ventura: "58999f0449db4ac31542005cfa3ba5b9be8f2e0c5387c1c6f5e45af0efa3bcd4"
    sha256 sonoma:        "19b85e51fb483e11137526bc86ad6b679693e1e310fbfa14e72d5e69f04517ed"
    sha256 ventura:       "03c2514f40f78da208b4b4f083f474a115b3014b3b4202d219502f445d058179"
    sha256 arm64_linux:   "26b0ad5264410984e466e2687240c3a8df1a6f024708106dd80f2cb6c46aa966"
    sha256 x86_64_linux:  "e2d2919e86ab3b341bb4552c4ff84e81a46912136ce4d55a28609780d066de03"
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
