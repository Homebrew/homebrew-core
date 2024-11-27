class Gpa < Formula
  desc "Graphical user interface for the GnuPG"
  homepage "https://www.gnupg.org/related_software/gpa/"
  license "GPL-3.0-or-later"
  revision 4

  stable do
    url "https://gnupg.org/ftp/gcrypt/gpa/gpa-0.10.0.tar.bz2"
    mirror "https://deb.debian.org/debian/pool/main/g/gpa/gpa_0.10.0.orig.tar.bz2"
    sha256 "95dbabe75fa5c8dc47e3acf2df7a51cee096051e5a842b4c9b6d61e40a6177b1"

    depends_on "gtk+" # TODO: Switch to `gtk+3` next release
  end

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gpa/"
    regex(/href=.*?gpa[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "9623cd359c6d3fa33bc0e24f05511b18a9302683aa9517d3ff462055d794780b"
    sha256 arm64_ventura:  "d7b108de57be92858293117242e4936bd8c89d04d0eb2beda5651054bf3281dc"
    sha256 arm64_monterey: "1fd644f78fd079f2cba7855e3972307dae86c0f9153589c23cd45c1ec69e5dc3"
    sha256 sonoma:         "3ff853e6943714626477e904c5b18b033e2177355eb61fad5ef8c701878cadad"
    sha256 ventura:        "0e82a2924eb523bc86d8008c89a8f05b99a4bc5b9b3c8d26e0758e8187b9da16"
    sha256 monterey:       "49fa165f0c5dab39320c4f586fd6129dd770956b2296c32b1d3c4b45267bd21d"
    sha256 x86_64_linux:   "5c8b02af48db9fe00d090e86c47d0977d10cb4427f8da5a83610b941aa59c5f2"
  end

  head do
    url "https://dev.gnupg.org/source/gpa.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gtk+3"
  end

  depends_on "desktop-file-utils" => :build
  depends_on "pkg-config" => :build

  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gpgme"
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

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make"
    system "make", "install"
  end

  test do
    system bin/"gpa", "--version"
  end
end
