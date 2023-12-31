class Fontconfig < Formula
  desc "XML-based font configuration API for X Windows"
  homepage "https://wiki.freedesktop.org/www/Software/fontconfig/"
  url "https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.14.2.tar.xz"
  sha256 "dba695b57bce15023d2ceedef82062c2b925e51f5d4cc4aef736cf13f60a468b"
  license "MIT"

  livecheck do
    url :stable
    regex(/href=.*?fontconfig[._-]v?(\d+\.\d+\.(?:\d|[0-8]\d+))\.t/i)
  end

  bottle do
    sha256 arm64_sonoma:   "38aa7dd551f49752ca7a1303e61e4a4e4f635eec83b95dbd8084007218c0f0e4"
    sha256 arm64_ventura:  "11cd488fc519d98142ed747300546eb65976c9a3bc973d955a934741c609b5df"
    sha256 arm64_monterey: "2e1558c0e3cb449da701c17897cdad76b21cc4a4af619a31848b08fa0a9fb2ca"
    sha256 arm64_big_sur:  "5fea615f3524a847df9ea7e336a615fd4c8d9d8b2fb0e89b0e684173e6a1614c"
    sha256 sonoma:         "9735684010a6472dd89d2a7f2fc3bac78e95c9c2aba8613944d73e3da99e8ad5"
    sha256 ventura:        "db394e8a4492db9d85b43c4afd1666b1691413fdd3815adf147aff6f92068198"
    sha256 monterey:       "9678cbf8549fae9c149db90c810bb0465c4725adcae61dbf35e295f76ec306d2"
    sha256 big_sur:        "337bbb8f41116814b2060eccd4b08f8df7021453b204551afad230ef9f067661"
    sha256 x86_64_linux:   "d92379c3a5f5c62a368e3d3ccd0db43d66a99c8c4347d0852d68b433b96706e0"
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
