class Freeciv < Formula
  desc "Free and Open Source empire-building strategy game"
  homepage "http://freeciv.org"
  url "https://downloads.sourceforge.net/project/freeciv/Freeciv%203.1/3.1.0/freeciv-3.1.0.tar.xz"
  sha256 "d746a883937b955b0ee1d1eba8b4e82354f7f72051ac4f514de7ab308334506e"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/freeciv[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)/}i)
  end

  bottle do
    sha256 arm64_sonoma:   "320250dbd312579ce73c00800c38f947c60577cfd12b52f742f4d118efcde8db"
    sha256 arm64_ventura:  "a5c285e5eab1609fe8f532ca3dddab508a598ef672bfa1727d13e968b1e34d00"
    sha256 arm64_monterey: "4c69f7e8153dc940b2512f38a0027fcae203480fc8a30c821afce02489653fa6"
    sha256 sonoma:         "f3b20676cc777c7640fe0df0fb9ea86edaae56d348e7c5ab6c5d55df18488524"
    sha256 ventura:        "20ff937a9252c7f67aba5f1e556f430f4a50bc9aefaf5632945cf919919cee73"
    sha256 monterey:       "a57309a396244c18948c8f3651351231d47b84e599b6a270bf855f783487f7c3"
    sha256 x86_64_linux:   "5fea1e4ce55564cc0ff577fc92c1f518561db4ef3a897b5afaf393280fb47815"
  end

  head do
    url "https://github.com/freeciv/freeciv.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "freetype"
  depends_on "gdk-pixbuf"
  depends_on "gettext"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "harfbuzz"
  depends_on "icu4c"
  depends_on "pango"
  depends_on "readline"
  depends_on "sdl2"
  depends_on "sdl2_mixer"
  depends_on "sqlite" # try to change to uses_from_macos after python is not a dependency

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
      assert_predicate testpath/file, :exist?
    end

    fork do
      system bin/"freeciv-server", "-l", testpath/"test.log"
    end
    sleep 5
    assert_predicate testpath/"test.log", :exist?
  end
end
