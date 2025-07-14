class Fontconfig < Formula
  desc "XML-based font configuration API for X Windows"
  homepage "https://wiki.freedesktop.org/www/Software/fontconfig/"
  url "https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.16.0.tar.xz"
  sha256 "6a33dc555cc9ba8b10caf7695878ef134eeb36d0af366041f639b1da9b6ed220"
  license "MIT"

  livecheck do
    url :stable
    regex(/href=.*?fontconfig[._-]v?(\d+\.\d+\.(?:\d|[0-8]\d+))\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "c3a7405dd151a87f72e7f99c95150da1fc8320ee817c3a17f15a493e1e01057c"
    sha256 arm64_sonoma:  "3ddfba863428fbb47be87178f2beaedd1a2c248724a3ce421c3f20bbecb035f1"
    sha256 arm64_ventura: "9af1bb1acad87514d53aa77cab95e15200794466c4618e9f96446b2113aa6dba"
    sha256 sonoma:        "37befec606c968bf0e3664d53a0cef5fbc013aa851f1c3d534b8f5f7a5af1de1"
    sha256 ventura:       "e09a65225015698a10e7c185d5de1d5b0976a672d57d5e8d65096b2bd03bb9fd"
    sha256 arm64_linux:   "a976210901014cc178e600d4e80df3f4d4c3bf86b67aabeacbe5fe27b8363d92"
    sha256 x86_64_linux:  "040b8c1ce9fd3d3022f26e1400b19b757cfd993da9e819c5c0956d3a38f42f00"
  end

  head do
    url "https://gitlab.freedesktop.org/fontconfig/fontconfig.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
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
    system "./configure", "--disable-silent-rules",
                          "--disable-docs",
                          "--enable-static",
                          "--with-add-fonts=#{font_dirs.join(",")}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}",
                          *std_configure_args
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
