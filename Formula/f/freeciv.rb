class Freeciv < Formula
  desc "Free and Open Source empire-building strategy game"
  homepage "http://freeciv.org"
  url "https://downloads.sourceforge.net/project/freeciv/Freeciv%203.1/3.1.1/freeciv-3.1.1.tar.xz"
  sha256 "b2bd00c0e2a6c81bcb52aa0dddf81f2f4543705bf7a9fcd5afac3f7b3fff5ef6"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/freeciv[._-]v?(\d+(?:\.\d+)+)\.(?:t|zip)/}i)
  end

  bottle do
    sha256 arm64_sonoma:   "13743ff39d32c71d7e8e85d9f56ffb6db822e02e150decb632ebd2ba7584acfe"
    sha256 arm64_ventura:  "fa4129a8fb656b7ef6b2f202626b539c509fa0d16fba8b150a463dcb0fe3b8c6"
    sha256 arm64_monterey: "3ca4c277f69f1f8ddfe2e9b92505ea0bca8e62c663d83c577037808b98465f16"
    sha256 sonoma:         "d987830d8d6054076d69131f95466a706c984f77fc22b8f2a641698125c7eb8f"
    sha256 ventura:        "7dcd1121e9149e4732654f558c2eed7059e2ec56d9094dae9535820c4a554e0e"
    sha256 monterey:       "01d31e792beebbed189fe71500115f4e2b7d3db0fff4078fcec15329054e261e"
    sha256 x86_64_linux:   "efcced6def87a47c2addc8ff1dd427180ea419f455c7bd1635e636ec53e0d03e"
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
