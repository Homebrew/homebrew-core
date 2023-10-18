class Freeciv < Formula
  desc "Free and Open Source empire-building strategy game"
  homepage "http://freeciv.org"
  url "https://downloads.sourceforge.net/project/freeciv/Freeciv%203.0/3.0.8/freeciv-3.0.8.tar.xz"
  sha256 "3b5aa32f628890be1741c3ac942cee82c79c065f8db6baff18d734a5c0e776d4"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/freeciv[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)/}i)
  end

  bottle do
    sha256 arm64_sonoma:   "25b8029d258012c3df04f7106422432a9607ac5abf437884c10c3ccbd379552d"
    sha256 arm64_ventura:  "12103450985cb49a61edf1d54047ddfec154ef20a60cad28015369a729771c63"
    sha256 arm64_monterey: "c577c7eb56ce28f3972b8d342237f6cd60dfcbd87679abfe74ba7dbe048eb74e"
    sha256 arm64_big_sur:  "5ab40e524f2c262b68994733ac5b33c2006ffc14fc2299b4d9a6624b14470317"
    sha256 sonoma:         "09f9dc123ebf438ea715611c45914a99d1c6b7d44bdc99701a50af4cc1e66840"
    sha256 ventura:        "c3c647835c5c603896ce2bd39d9cfc5fb7c14a7f7ead7d5ee6bfbaad869fdaa8"
    sha256 monterey:       "c26d89d174ee14e179c6844d15ae988856d30c67b000d7bcfbb1f0bc274c49df"
    sha256 big_sur:        "f83674bd7f14a400f4c13094c845b37f739806854a65d8b0719b9461296e99e6"
    sha256 x86_64_linux:   "883cc5053a98eb6d02459c9ae496d348fafd5a92b7c9a9d0073e0f5afd0187ed"
  end

  head do
    url "https://github.com/freeciv/freeciv.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "atk"
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
      --disable-debug
      --disable-dependency-tracking
      --disable-gtktest
      --disable-silent-rules
      --disable-sdltest
      --disable-sdl2test
      --disable-sdl2framework
      --enable-client=gtk3.22
      --enable-fcdb=sqlite3
      --prefix=#{prefix}
      --with-readline=#{Formula["readline"].opt_prefix}
      CFLAGS=-I#{Formula["gettext"].include}
      LDFLAGS=-L#{Formula["gettext"].lib}
    ]

    if build.head?
      inreplace "./autogen.sh", "libtoolize", "glibtoolize"
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
  end

  test do
    system bin/"freeciv-manual"
    assert_predicate testpath/"civ2civ36.mediawiki", :exist?

    fork do
      system bin/"freeciv-server", "-l", testpath/"test.log"
    end
    sleep 5
    assert_predicate testpath/"test.log", :exist?
  end
end
