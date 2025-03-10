class EasyTag < Formula
  desc "Application for viewing and editing audio file tags"
  homepage "https://wiki.gnome.org/Apps/EasyTAG"
  url "https://download.gnome.org/sources/easytag/2.4/easytag-2.4.3.tar.xz"
  sha256 "fc51ee92a705e3c5979dff1655f7496effb68b98f1ada0547e8cbbc033b67dd5"
  license "GPL-2.0-or-later"
  revision 12

  bottle do
    sha256 arm64_sequoia: "8c29dc74a17f41bde4c53800d5e27b53b3fe54e14231cf7bb4825826007edae9"
    sha256 arm64_sonoma:  "996d40e2aec8366f8187e8bdf1f0dc19dfdc0b87803fc01ae4b8d3f1b0d4c7ff"
    sha256 arm64_ventura: "72758b1a6c3f5ad69114ce3843b7bbb374b71540799d41a388ca586f90b65a5a"
    sha256 sonoma:        "fca7fab0f6df02b7d25324d2ef86c3387f4a587ab2a8ec475b2cb54d25e34889"
    sha256 ventura:       "198606e1a0afe6e1659c588b89d75e6bd328bf8afff9748ee4cb6e908f94e64e"
    sha256 x86_64_linux:  "3076252648242e093cbd37926bf16a6a9a3967b4123355d5fc5f2d115ee46095"
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
