class Freeciv < Formula
  desc "Free and Open Source empire-building strategy game"
  homepage "https://freeciv.org/"
  url "https://downloads.sourceforge.net/project/freeciv/Freeciv%203.1/3.1.5/freeciv-3.1.5.tar.xz"
  sha256 "0d9f687ff950a77a9fa0af66108a7f67da717fd40c3a0ca4c0a4f4a3f0214b33"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/freeciv[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)/}i)
  end

  bottle do
    sha256 arm64_sequoia: "41b72392d0c7bda4ef87ebb4c3cb23a75437d47589e67947bc62429e53e86faa"
    sha256 arm64_sonoma:  "d7d140af12010c0adc38d54cfdd9750803799a99ce5411a69d1c6e355c54a4e6"
    sha256 arm64_ventura: "2694d772632c1c690fcb8398888753b44d06156ad79dd3c7dbccc1a63a6214e9"
    sha256 sonoma:        "14192305f9802303a698451bef2b3985888ff2929b30754d1a4b4f4a90699db7"
    sha256 ventura:       "5ea34567361cbccb36c9421ba3b8a10ce14579e25dc059181f4316d0760619ef"
    sha256 arm64_linux:   "2bc1f434418b08b9fe66ef1c3b3d924559e4a99b7ffb4d9e6c68b709a2153b1c"
    sha256 x86_64_linux:  "0da80ceb53a0bd7e464cab9b9a5806a57c3cdde7c408fdc6becd8b405822f0b4"
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
