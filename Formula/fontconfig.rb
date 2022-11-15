class Fontconfig < Formula
  desc "XML-based font configuration API for X Windows"
  homepage "https://wiki.freedesktop.org/www/Software/fontconfig/"
  url "https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.14.1.tar.xz"
  sha256 "298e883f6e11d2c5e6d53c8a8394de58d563902cfab934e6be12fb5a5f361ef0"
  license "MIT"

  livecheck do
    url :stable
    regex(/href=.*?fontconfig[._-]v?(\d+\.\d+\.(?:\d|[0-8]\d+))\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "d0dc5e1f28f8c7ded2351b6da95dc10c483f6a302390660b2b861a3b94c6cd18"
    sha256 arm64_monterey: "decbdcc8765f8aa654452570b3f2b151e319944210479a5637d6614a44dc0947"
    sha256 arm64_big_sur:  "143b68331a6332cc0e1e3883e2863d65139869ac5bf1823bbe49fd2127d2c7f5"
    sha256 ventura:        "356fe902b2f81d7f039e6f5a7a0eddaa9f84553a660f54894bbf25034119aa6b"
    sha256 monterey:       "e910d7850f921d5d0b5bdd50080c3985213e2a0eff0181bab4fd6f375d386862"
    sha256 big_sur:        "8479e4d4cb8c71606a221e9fad0c0d1d7089302eaece07e47489429a5dac1fd3"
    sha256 catalina:       "1d6767bcdcf4390f88c120ca0beff6104d3339880950342802ad8b4b51520a6e"
    sha256 x86_64_linux:   "0c84e31071c824f713407a666947cc4c6968c8a6c2a8733dd7818cfbab469749"
  end

  head do
    url "https://gitlab.freedesktop.org/fontconfig/fontconfig.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"

  uses_from_macos "gperf" => :build
  uses_from_macos "python" => :build, since: :catalina
  uses_from_macos "bzip2"
  uses_from_macos "expat"

  on_linux do
    depends_on "gettext" => :build
    depends_on "json-c" => :build
    depends_on "util-linux"
  end

  def install
    font_dirs = %w[
      /System/Library/Fonts
      /Library/Fonts
      ~/Library/Fonts
    ]

    font_dirs << Dir["/System/Library/Assets{,V2}/com_apple_MobileAsset_Font*"].max if MacOS.version >= :sierra

    system "autoreconf", "-iv" if build.head?
    ENV["UUID_CFLAGS"] = "-I#{Formula["util-linux"].include}" if OS.linux?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-docs",
                          "--enable-static",
                          "--with-add-fonts=#{font_dirs.join(",")}",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}"
    system "make", "install", "RUN_FC_CACHE_TEST=false"
  end

  def post_install
    ohai "Regenerating font cache, this may take a while"
    system "#{bin}/fc-cache", "-frv"
  end

  test do
    system "#{bin}/fc-list"
  end
end
