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
    sha256 arm64_ventura:  "243211699bfb1369aa888a5c30ab18e803ee89f0b6c3b3d206d8120ab8e431b0"
    sha256 arm64_monterey: "1590366d6e44095fdb999241d64e81747215d0502378c191f73981ea4b21968a"
    sha256 arm64_big_sur:  "c603b1b3842e3de3e0681914d01063e923c50bbb5b5f17c4f93611541b28aee5"
    sha256 monterey:       "6bd89f45f20c5739ba53348933f843d256383eb30b28723d1a64a23ad565b1bc"
    sha256 big_sur:        "b2d63813898c4dfa6f33d344a9f54a6ec8e31a2b326e70906bff8bc2a18411a2"
    sha256 catalina:       "6bd0d5ba7717d89e987125e1cdde7900bcba4d116ce78b9d151a221c637188b2"
    sha256 x86_64_linux:   "1c1706b94f8b9408ce14a9880d67e9dbd22724b85f7ba9eb625c9d91fd43323f"
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
