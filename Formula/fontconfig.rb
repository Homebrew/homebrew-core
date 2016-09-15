class Fontconfig < Formula
  desc "XML-based font configuration API for X Windows"
  homepage "https://wiki.freedesktop.org/www/Software/fontconfig/"
  revision 2

  stable do
    url "https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.12.1.tar.bz2"
    sha256 "b449a3e10c47e1d1c7a6ec6e2016cca73d3bd68fbbd4f0ae5cc6b573f7d6c7f3"

    patch do
      # Fixes https://bugs.freedesktop.org/show_bug.cgi?id=97546, "fc-cache
      # failure with /System/Library/Fonts", and #4172.
      #
      # Patch from upstream maintainer Akira TAGOH. See
      #   https://bugs.freedesktop.org/show_bug.cgi?id=97546#c7
      #   https://bugs.freedesktop.org/attachment.cgi?id=126464
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/3790bcd/fontconfig/patch-2.12.1-fccache.diff"
      sha256 "e7c074109a367bf3966578034b20d11f7e0b4a611785a040aef1fd11359af04d"
    end
  end

  # The bottle tooling is too lenient and thinks fontconfig
  # is relocatable, but it has hardcoded paths in the executables.
  bottle do
    cellar :any
    sha256 "731c2a5c33f638022c7f915dda1eb634857d78acdb516820b4ce5dc6b8da87f6" => :sierra
    sha256 "48bd2e66df68bf40257db0c2af87acd834d187e007d63a7332cb273ca1ebb495" => :el_capitan
    sha256 "ff7170125a03a512372cedef7584f0734966bbefcda59383e69001f846c5e708" => :yosemite
    sha256 "e83ac5fafe24b49700b0bf15c63d076a95da2ef525760a3f3ca162e26325b953" => :mavericks
  end

  pour_bottle? do
    reason "The bottle needs to be installed into /usr/local."
    # c.f. the identical hack in lua
    # https://github.com/Homebrew/homebrew/issues/47173
    satisfy { HOMEBREW_PREFIX.to_s == "/usr/local" }
  end

  head do
    url "https://anongit.freedesktop.org/git/fontconfig", :using => :git

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  keg_only :provided_pre_mountain_lion

  option :universal

  depends_on "pkg-config" => :build
  depends_on "freetype"

  def install
    ENV.universal_binary if build.universal?
    system "autoreconf", "-iv" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-static",
                          "--with-add-fonts=/System/Library/Fonts,/Library/Fonts,~/Library/Fonts",
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
