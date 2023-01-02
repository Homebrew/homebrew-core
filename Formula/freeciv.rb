class Freeciv < Formula
  desc "Free and Open Source empire-building strategy game"
  homepage "http://freeciv.org"
  url "https://downloads.sourceforge.net/project/freeciv/Freeciv%203.0/3.0.5/freeciv-3.0.5.tar.xz"
  sha256 "4d2e22da54cf1e2821f78d0743ca25429c38dd7802414cd9e6090ad52f49ee83"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/freeciv[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)/}i)
  end

  bottle do
    sha256 arm64_ventura:  "17172f5a4fe4631dc59cc655989b2e2494a609f2cc421ee9030723a5235d84f3"
    sha256 arm64_monterey: "2cb9e80fc11522e27a95fa7f5e285bd2e2f9a835b1915e8c10bfe54390a0b7fd"
    sha256 arm64_big_sur:  "eb2cc8ed171224639b45d503e7ad86ee89ff1a67c2178aeff1c486dc8ae70bd7"
    sha256 ventura:        "f59557bd0ac5ecde2499fba18f082181072a1eec228843a1fab158bd7e2349a6"
    sha256 monterey:       "7c7a1f032065718ea222027d46bcec9ad67f39ffb92b6230ff874a186c989511"
    sha256 big_sur:        "ea9f8c372d71ad373d0a4d6b958a6d63ccf302b52e89376f29c44b26eae61087"
    sha256 x86_64_linux:   "f0a1af7d18de79b8ba4f693f8dfe87db10e1ba4f25941091b27b58417ea3f6cb"
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
