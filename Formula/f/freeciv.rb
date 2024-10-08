class Freeciv < Formula
  desc "Free and Open Source empire-building strategy game"
  homepage "https://freeciv.org/"
  url "https://downloads.sourceforge.net/project/freeciv/Freeciv%203.1/3.1.2/freeciv-3.1.2.tar.xz"
  sha256 "7ab19d218a023306091a34e5c3bc3fd70981d8ebc4b9542c1646827dede55828"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/freeciv[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)/}i)
  end

  bottle do
    sha256 arm64_sequoia: "680ebc2640405a5032fee2a53397115a50556e8257c147be7c1c775eb3874f89"
    sha256 arm64_sonoma:  "c1350e24ea132c9944db0f38af8f13acb4e107d8a42711de629c9e36b0263a5d"
    sha256 arm64_ventura: "9f7090f2d2ebb148d13c3b2e8aa2402d524536bbb4b3fd6db4b3bdc8099ebcea"
    sha256 sonoma:        "2030be34217e8e09d737dd28c0533800755d7d4e0c5eca28829a10dfe86e35f9"
    sha256 ventura:       "19fc9d78f32a0e9e2dd12de560a8a1e61b58a6ade7c15771c175ee88fe9b129e"
    sha256 x86_64_linux:  "5e0150ea9f04dd3285fe157a09d5a7a24efe875b0cb1dfa2ba6130e7fc1ca936"
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
  depends_on "icu4c@75"
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
      assert_predicate testpath/file, :exist?
    end

    fork do
      system bin/"freeciv-server", "-l", testpath/"test.log"
    end
    sleep 5
    assert_predicate testpath/"test.log", :exist?
  end
end
