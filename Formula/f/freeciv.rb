class Freeciv < Formula
  desc "Free and Open Source empire-building strategy game"
  homepage "https://freeciv.org/"
  url "https://downloads.sourceforge.net/project/freeciv/Freeciv%203.2/3.2.0/freeciv-3.2.0.tar.xz"
  sha256 "828e831b672a46b316f6fdb23e670230b2ec9c05b6fe8c66fc9f7e1c0679fcde"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/freeciv[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)/}i)
  end

  bottle do
    sha256 arm64_tahoe:   "1bc7f00df7e35af121454d708542473a2360dcece37f7407c813dd185b677a40"
    sha256 arm64_sequoia: "fb2c867eb030fbbc439cbb4dccc2acf235bf0460b03cd578dbe7514d54f4731c"
    sha256 arm64_sonoma:  "4ac90c21f7a924ab576a1219cceb5243bc9e0c4310f94842ed5be18b2f09d7e7"
    sha256 arm64_ventura: "643274522efcd8b67fea947163b7a60e67bc5884d3f3783710bc4fa7254d9f9f"
    sha256 sonoma:        "96dca83d48963577b8e1dd30d11e2e6e28dfe547c7c67c17d7c7caf5433d98bd"
    sha256 ventura:       "2af8397bb9e90755f7e83a4741e5c3a5ea68f4e382aa642bb6b231906baf6886"
    sha256 arm64_linux:   "9ef1b6004f65398a5dc89f8171953074b403989199b5c689155f4cdd492b9710"
    sha256 x86_64_linux:  "e5495fecadc9fd988768f140897468e6456f083d3e9580908e210217f33226aa"
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
