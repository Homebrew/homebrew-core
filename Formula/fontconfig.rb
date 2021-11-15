class Fontconfig < Formula
  desc "XML-based font configuration API for X Windows"
  homepage "https://wiki.freedesktop.org/www/Software/fontconfig/"
  url "https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.13.1.tar.bz2"
  sha256 "f655dd2a986d7aa97e052261b36aa67b0a64989496361eca8d604e6414006741"
  license "MIT"

  livecheck do
    url :stable
    regex(/href=.*?fontconfig[._-]v?(\d+\.\d+\.(?:\d|[0-8]\d+))\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "7b4e599e0ba2f56b5b3e22b83bebb1dc4e38c10b00d231c9c38319df31c7f65c"
    sha256 arm64_big_sur:  "19dd1db44a74a3fedf20bc6576f81469d0ba6c4301fc865a56c3bbda2733d519"
    sha256 monterey:       "7c40dab2076798df8b741c132bfc294f1c3fe3535c683d293b6711f2574d8675"
    sha256 big_sur:        "ee5961891c9e943c8bea6ad280d2346caa2d3efafdbd726670e663d0bdfdb010"
    sha256 catalina:       "64ff208b28613dfe2a65b9d74fd9b0129f3ca7e423db78329144cdaf51b36f70"
    sha256 mojave:         "1c704a5a4249252bf42dc4f2a458f911a7858a931858ad257d9ec39978ca5095"
    sha256 high_sierra:    "3b763143a4d6e3c74b3a8b237d2e5a383696347ea3599d07957f73a3f6521d23"
    sha256 sierra:         "631531c4eb502bd97e4a5bef30760d1eef87dd50306ef2defb9460ac3338cfe1"
    sha256 el_capitan:     "40d70137a970e257de5cf1251b10d56d7db835faee88a9f4c020b4a4e4f82eb1"
    sha256 x86_64_linux:   "eccabe463fb0ecc1537d19628240caec276095a4afbbbc80233ac03c841cd4fe"
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
  uses_from_macos "bzip2"
  uses_from_macos "expat"

  on_linux do
    depends_on "gettext" => :build
    depends_on "json-c" => :build
    depends_on "util-linux"
  end

  # Fix crash issues on arm64.
  # Remove with the next release.
  patch do
    url "https://github.com/freedesktop/fontconfig/commit/6def66164a36eed968aae872d76acfac3173d44a.patch?full_index=1"
    sha256 "1dbe6247786c75f2b3f5a7e21133a3f9c09189f59fff08b2df7cb15389b0e405"
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
