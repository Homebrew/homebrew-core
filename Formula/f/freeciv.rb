class Freeciv < Formula
  desc "Free and Open Source empire-building strategy game"
  homepage "https://freeciv.org/"
  url "https://downloads.sourceforge.net/project/freeciv/Freeciv%203.2/3.2.2/freeciv-3.2.2.tar.xz"
  sha256 "ed230084e885d19d82170a8b39e43e3291ec446c37239bf2bee8e11245c88960"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/freeciv[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)/}i)
  end

  bottle do
    sha256 arm64_tahoe:   "d14025dbf33952ef5a2e92961ce2636c92cfde6da720b08d5707c8ce1d958058"
    sha256 arm64_sequoia: "0974803415c4a238ab169728669c411e9248ed4d6211f054a1564614877131e1"
    sha256 arm64_sonoma:  "b6f14af71baef5372e9ab1ca1c503cf6c3a70da311a51f13691bd27e306f317c"
    sha256 sonoma:        "80d3934731265d703dcc0fe41adee6521f9933e70cd27285d0a5a16ec9eb46ba"
    sha256 arm64_linux:   "107059c5368d6e5234e8edaa8e231af3c9d23e0f862df580bbe5886e2ca2669c"
    sha256 x86_64_linux:  "d01d3978b1e60f7f12cd7bded74ac0122f70591dc5beec0014f17bf011533fe4"
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
  depends_on "icu4c@78"
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
