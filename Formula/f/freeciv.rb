class Freeciv < Formula
  desc "Free and Open Source empire-building strategy game"
  homepage "http://freeciv.org"
  url "https://downloads.sourceforge.net/project/freeciv/Freeciv%203.0/3.0.10/freeciv-3.0.10.tar.xz"
  sha256 "c185c8ea0d6a2e974a5ad12fb837ca3ceb9aed3e7e884355f01035f5e779d23c"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/freeciv[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)/}i)
  end

  bottle do
    sha256 arm64_sonoma:   "5e5b94321fbb77d1926986ec691f8950c9c7937d02e2fb4cfa8ffdd86d58c05d"
    sha256 arm64_ventura:  "c0eeb1a2a4a08be503988e9ac45c0d4ab339e4eba13a0456246874d9ee01bac9"
    sha256 arm64_monterey: "d92579e9fcf5b96ddc8cb798b3e912e6fc6de8332a165577d3fc89feeb83425b"
    sha256 sonoma:         "5ce17c5339b46dcef23f65ce6c12f63bfaf651b50ea114fd9d5935e1f87efad7"
    sha256 ventura:        "ee1066f80b96fd5392fa8a3265b32cb758ffa6b6535398d6a041983b1ced0539"
    sha256 monterey:       "5c01f2a05ae5ff19f257a206b1b9492c41bde66259e6c647dad62060713564c5"
    sha256 x86_64_linux:   "56bea7e5262cc73a04df8cc9584caedf60461337925575bc8450cccb57faa5e9"
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
