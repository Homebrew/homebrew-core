class Freeciv < Formula
  desc "Free and Open Source empire-building strategy game"
  homepage "https://freeciv.org/"
  url "https://downloads.sourceforge.net/project/freeciv/Freeciv%203.1/3.1.4/freeciv-3.1.4.tar.xz"
  sha256 "14999bb903c4507cc287d5a8dd1b89eee623bb41b4e01e0836567fb5f13296e4"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/freeciv[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)/}i)
  end

  bottle do
    sha256 arm64_sequoia: "bb24fc0fadc8f16b3c9518544e0bbf108dee3c75bdb2265125614f762967d8ed"
    sha256 arm64_sonoma:  "f8ade62bfbddee03015e60be7469b934c68ac117060227b64f093de2e9005cd5"
    sha256 arm64_ventura: "751d5859aafda7a2f22f47e5aa83f8e7740aae1fc72310d67ee2d0efa2fb8351"
    sha256 sonoma:        "46928f3bc95629d3149e3ee1a44071ede46d2a7dc1e3c7d3d5ddbb672899f97f"
    sha256 ventura:       "c984ccc6dfd5d44d4cc24f834ddc7409f8fb7453084d5ca1296f6aebe0c2ebdc"
    sha256 arm64_linux:   "163e31e82cf0fbb9b2bbecf83d3965275db2aa1efcced265c0c60549f9b36e5a"
    sha256 x86_64_linux:  "8c414f76445e8eb8bcdaf130941e9d6a39c41e6a51c29d00da4dd439a06b9eac"
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
  depends_on "icu4c@77"
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
