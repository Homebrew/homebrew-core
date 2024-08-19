class Freeciv < Formula
  desc "Free and Open Source empire-building strategy game"
  homepage "https://freeciv.org/"
  url "https://downloads.sourceforge.net/project/freeciv/Freeciv%203.1/3.1.2/freeciv-3.1.2.tar.xz"
  sha256 "7ab19d218a023306091a34e5c3bc3fd70981d8ebc4b9542c1646827dede55828"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/freeciv[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)/}i)
  end

  bottle do
    sha256 arm64_sonoma:   "b7162ce0379dfbe1e2ec91c12522440eb1be2683c8b174f870fcebc20bf8a68d"
    sha256 arm64_ventura:  "8c7b90207942264128cd60c0a374a0ae72c953da6be2e3f205a4aab8a431b76c"
    sha256 arm64_monterey: "ad9ef0dc1940fa154c346c487a120fa37a2590ce0e91f9947cb1a8d6eaea60c8"
    sha256 sonoma:         "c35ba1e4befb8609e2a0b1ad111a9e4308582a68c3b6b08732d4120caed44fab"
    sha256 ventura:        "ed923f2a702eb2ba87e801339b03bc30387d0e9bd60ada5a014584686c642a72"
    sha256 monterey:       "6f7c5e1a7b041322c559d1aae0e40a77d09f70e3e93125ce941d9fc1d3e17b31"
    sha256 x86_64_linux:   "32b2b6cab1b82d3863f0db79617dcb41519604e6f8e0dbb4ca81fe74e224ca64"
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
