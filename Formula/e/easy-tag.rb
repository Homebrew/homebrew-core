class EasyTag < Formula
  desc "Application for viewing and editing audio file tags"
  homepage "https://wiki.gnome.org/Apps/EasyTAG"
  url "https://download.gnome.org/sources/easytag/2.4/easytag-2.4.3.tar.xz"
  sha256 "fc51ee92a705e3c5979dff1655f7496effb68b98f1ada0547e8cbbc033b67dd5"
  license "GPL-2.0-or-later"
  revision 12

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "3f95f44be0c6742028c5395152f2c93c14c83a6ffaeff8ed1105271fce8d5051"
    sha256 arm64_sequoia: "d04b63e28faa7da6ebab02e67dbf9b815cb4da4e382d98cac430184426a73f9b"
    sha256 arm64_sonoma:  "6f77c6d7fe588b1bf054cb77d0a9f3fc1a3021b8197ed2e2f30f08441ebb7749"
    sha256 arm64_ventura: "7aab98173864bbc6c9be2abd2e1ffaaa0629820740ac7299e3ee31bd858da934"
    sha256 sonoma:        "01e68eed3d45841e47f3dc5d881a96edcbb687795cb79c94adcf51f83bd291a4"
    sha256 ventura:       "e66e57435c818f0c4fd5e9a926e4716fee394f91c2391be98f0a5c31514eb897"
    sha256 arm64_linux:   "8ea78b5349b575c0af14b9b98462173493f74b418330fd4b3408bf307d4139b4"
    sha256 x86_64_linux:  "7732a032b2ed7d6aafbe639d15ecd7d2583b286b1ba7e6433e6b58d9d9f0935f"
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
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
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
    # Disable test on Linux because it fails with:
    # Gtk-WARNING **: 18:38:23.471: cannot open display
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    system bin/"easytag", "--version"
  end
end
