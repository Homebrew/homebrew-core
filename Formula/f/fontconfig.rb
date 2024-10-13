class Fontconfig < Formula
  desc "XML-based font configuration API for X Windows"
  homepage "https://wiki.freedesktop.org/www/Software/fontconfig/"
  url "https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.15.0.tar.xz"
  sha256 "63a0658d0e06e0fa886106452b58ef04f21f58202ea02a94c39de0d3335d7c0e"
  license "MIT"

  livecheck do
    url :stable
    regex(/href=.*?fontconfig[._-]v?(\d+\.\d+\.(?:\d|[0-8]\d+))\.t/i)
  end

  bottle do
    sha256 arm64_sequoia:  "032ec9dfdfc3005bf76ea31b943073c7ac6d4cb42151798d6ba7a05dd90fd267"
    sha256 arm64_sonoma:   "4732e8c8cd6f940fa3ace12a5a5428baaef29bdccf9bc520fa4d37a1f0bf639c"
    sha256 arm64_ventura:  "deeb5f60979bcc3d57a201914ceba3ad83ca36139be32620f529b5d69f0d1c38"
    sha256 arm64_monterey: "93df98ef8a2740e22c028048bfa34f2635b4265ef406462d89705f9c39df969c"
    sha256 sonoma:         "bbf54fe755e483815ed53755d3c5afbcba1560b5ad0b4d8b0abda3403be45079"
    sha256 ventura:        "aedf10972e0376c56d4c130d3dd51e14b61badeb2686b865eb56a2bdfb77b5b5"
    sha256 monterey:       "470c4c7982cdffd7abf44f18a6614830112484d493e0559d406a90bea19adee9"
    sha256 x86_64_linux:   "1cb0f103706d1199c9917ec6908d9f027eb9688faee40a46bcd32df1173c96b4"
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

    if OS.mac? && MacOS.version >= :sierra
      font_dirs << Dir["/System/Library/Assets{,V2}/com_apple_MobileAsset_Font*"].max
    end

    system "autoreconf", "--force", "--install", "--verbose" if build.head?
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
    system bin/"fc-cache", "-frv"
  end

  test do
    system bin/"fc-list"
  end
end
