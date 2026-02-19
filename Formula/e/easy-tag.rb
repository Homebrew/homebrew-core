class EasyTag < Formula
  desc "Application for viewing and editing audio file tags"
  homepage "https://wiki.gnome.org/Apps/EasyTAG"
  url "https://download.gnome.org/sources/easytag/2.4/easytag-2.4.3.tar.xz"
  sha256 "fc51ee92a705e3c5979dff1655f7496effb68b98f1ada0547e8cbbc033b67dd5"
  license "GPL-2.0-or-later"
  revision 12

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "8251a64714fcb33ae2d6952b837cc4441424c68d85194fe85fa1ffb840d8f1af"
    sha256 arm64_sequoia: "dd969dbf8e9fc12844800194aa455dff8a3196e556167b54b78125e82ff0dfd6"
    sha256 arm64_sonoma:  "1bb2f7a658bb7ef3cd2d58436cec8bcf915848e13a56537c1085a6153fa02403"
    sha256 sonoma:        "bb4e3ef00876303f85ddd0013fb353e26317f4ac7d52e3c204a9ff583c4b3be5"
    sha256 arm64_linux:   "a0e221b36fad5782d5a9a63e55a636ffef07f8780f33263a63752ff9fa11935d"
    sha256 x86_64_linux:  "9d32bfcd076b17f4e7f4fe1572e456d9a5539d6e7c95b2ecfd14fd960204e5f3"
  end

  depends_on "appstream-glib" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "yelp-tools" => :build

  depends_on "adwaita-icon-theme"
  depends_on "at-spi2-core"
  depends_on "cairo"
  depends_on "flac"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "harfbuzz"
  depends_on "hicolor-icon-theme"
  depends_on "id3lib"
  depends_on "libid3tag"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "pango"
  depends_on "speex"
  depends_on "taglib"
  depends_on "wavpack"

  uses_from_macos "perl" => :build

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
    depends_on "xorg-server" => :test
    depends_on "zlib-ng-compat"
  end

  # easy-tag doesn't support taglib 2.x
  patch do
    url "https://sources.debian.org/data/main/e/easytag/2.4.3-9/debian/patches/03_port-to-taglib-2.patch"
    sha256 "8b096f58ce08a059a992428fb239f8ab3a5887434bf8db33302a8635d0965aa4"
  end

  patch do
    url "https://sources.debian.org/data/main/e/easytag/2.4.3-9/debian/patches/04_taglib-2-further-fix.patch"
    sha256 "3a5a7880e56a011a291b4b2c2c9ba1d378acc505c7eebd0a306735afc58c7b9f"
  end

  def install
    inreplace "src/tags/gio_wrapper.cc" do |s|
      s.gsub! "ulong", "unsigned long"
    end
    ENV["LIBTOOLIZE"] = "glibtoolize"
    system "autoreconf", "--force", "--install", "--verbose"
    ENV.append "LIBS", "-lz"
    ENV["DESTDIR"] = "/"

    system "./configure", "--disable-schemas-compile", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    cmd = "#{bin}/easytag --version"
    cmd = "#{Formula["xorg-server"].bin}/xvfb-run #{cmd}" if OS.linux? && ENV.exclude?("DISPLAY")
    assert_match version.to_s, shell_output(cmd)
  end
end
