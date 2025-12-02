class Freeciv < Formula
  desc "Free and Open Source empire-building strategy game"
  homepage "https://freeciv.org/"
  url "https://downloads.sourceforge.net/project/freeciv/Freeciv%203.2/3.2.1/freeciv-3.2.1.tar.xz"
  sha256 "3fc01ef55bfc9b9c2d71432d22a9fc5ab5892285d15d3dc888ec4bb288d21caa"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/freeciv[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)/}i)
  end

  bottle do
    sha256 arm64_tahoe:   "d2916cf88857431d3f9df982e77787fce62f4431a3f56e1f87875862664f4c35"
    sha256 arm64_sequoia: "2f4a5f156013900aa5c27ca16d81deb98cc9e107dfc612838901c90da9a35a12"
    sha256 arm64_sonoma:  "69e59172a8228b4e5209c29da5c892eb75b4d8c7857f7c4882ba4fdb404380ec"
    sha256 sonoma:        "b683352bccbeeb5ea862eeca561ce01d170a580d992fc4d701e0fe61488c6039"
    sha256 arm64_linux:   "bb6709793d0250b18557fa09254db43183dce74f7cb6566024a050a93753cde6"
    sha256 x86_64_linux:  "18cad79d35fd7f0020a737b583ab0b31f58a3e50a216ed135d0d51e79b960547"
  end

  head do
    url "https://github.com/freeciv/freeciv.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "adwaita-icon-theme"
  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "freetype"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "harfbuzz"
  depends_on "icu4c@78"
  depends_on "pango"
  depends_on "readline"
  depends_on "sdl2"
  depends_on "sdl2_mixer"
  depends_on "sqlite" # try to change to uses_from_macos after python is not a dependency
  depends_on "zstd"

  uses_from_macos "bzip2"
  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    ENV["ac_cv_lib_lzma_lzma_code"] = "no"

    args = %W[
      --disable-gtktest
      --disable-sdl2framework
      --disable-sdl2test
      --disable-sdltest
      --disable-silent-rules
      --enable-client=gtk3.22
      --enable-fcdb=sqlite3
      --with-readline=#{Formula["readline"].opt_prefix}
      CFLAGS=-I#{Formula["gettext"].include}
      LDFLAGS=-L#{Formula["gettext"].lib}
    ]

    if build.head?
      inreplace "./autogen.sh", "libtoolize", "glibtoolize"
      system "./autogen.sh", *args, *std_configure_args
    else
      system "./configure", *args, *std_configure_args
    end

    system "make", "install"
  end

  test do
    system bin/"freeciv-manual"
    %w[
      civ2civ31.html
      civ2civ32.html
      civ2civ33.html
      civ2civ34.html
      civ2civ35.html
      civ2civ36.html
      civ2civ37.html
      civ2civ38.html
    ].each do |file|
      assert_path_exists testpath/file
    end

    spawn bin/"freeciv-server", "-l", testpath/"test.log"
    sleep 5
    assert_path_exists testpath/"test.log"
  end
end
