class Freeciv < Formula
  desc "Free and Open Source empire-building strategy game"
  homepage "https://freeciv.org/"
  url "https://downloads.sourceforge.net/project/freeciv/Freeciv%203.1/3.1.4/freeciv-3.1.4.tar.xz"
  sha256 "14999bb903c4507cc287d5a8dd1b89eee623bb41b4e01e0836567fb5f13296e4"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/freeciv[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)/}i)
  end

  bottle do
    sha256 arm64_sequoia: "7fd05a35fcec8d2c5799f5f91c1d6043cdac5dfc85a109ad2db14e2615a28a75"
    sha256 arm64_sonoma:  "b8d4bc8ed3a79cec1946c1747cc83970f6629b0c5d9fa47b2b3b525b436e76ce"
    sha256 arm64_ventura: "b44bf3fcf731182c4c7d8953a26d5654f6bfcc8609f49d1fb60a92185ae6d3b9"
    sha256 sonoma:        "deef682ea166bf0bdd69a321eade1c1ff34101287cd7a7fbba3af6a9dad178f4"
    sha256 ventura:       "f8e960463d636caafc9294de686ea3a997a70eb36f1b68ba024ce4cbd823c471"
    sha256 x86_64_linux:  "7fdf4dc1402870e3c45e8d4b8c6ad7bb4a1f977f573a835750a535433a007014"
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
  depends_on "icu4c@76"
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
