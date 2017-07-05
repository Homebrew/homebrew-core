class Fontconfig < Formula
  desc "XML-based font configuration API for X Windows"
  homepage "https://wiki.freedesktop.org/www/Software/fontconfig/"
  url "https://www.freedesktop.org/software/fontconfig/release/fontconfig-2.12.4.tar.bz2"
  sha256 "668293fcc4b3c59765cdee5cee05941091c0879edcc24dfec5455ef83912e45c"

  # The bottle tooling is too lenient and thinks fontconfig
  # is relocatable, but it has hardcoded paths in the executables.
  bottle do
    rebuild 1
    sha256 "320647254df248fe051768352f6d671d7cc2347fc5d25a04a7a3c2c93cd7e731" => :sierra
    sha256 "3b52ab43bf9b6685d7a56c91e1792bf2faa701df97db8cb1f5b55a1c392120db" => :el_capitan
    sha256 "7fc0ad1907ed19ce3d2668fd46fc1b41da80b79cfb540c61edbfe5c0a2daa76c" => :yosemite
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

  depends_on "pkg-config" => :build
  depends_on "freetype"

  def install
    font_dirs = %w[
      /System/Library/Fonts
      /Library/Fonts
      ~/Library/Fonts
    ]

    if MacOS.version == :sierra
      font_dirs << "/System/Library/Assets/com_apple_MobileAsset_Font3"
    elsif MacOS.version == :high_sierra
      font_dirs << "/System/Library/Assets/com_apple_MobileAsset_Font4"
    end

    system "autoreconf", "-iv" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
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
