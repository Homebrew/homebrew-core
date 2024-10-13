class EasyTag < Formula
  desc "Application for viewing and editing audio file tags"
  homepage "https://wiki.gnome.org/Apps/EasyTAG"
  url "https://download.gnome.org/sources/easytag/2.4/easytag-2.4.3.tar.xz"
  sha256 "fc51ee92a705e3c5979dff1655f7496effb68b98f1ada0547e8cbbc033b67dd5"
  license "GPL-2.0-or-later"
  revision 10

  bottle do
    sha256 arm64_sequoia:  "69174334e32cc36f5782d2357320dc68e49790a51ea6c1c2d9822e9566aa750f"
    sha256 arm64_sonoma:   "c20d11415ff4338da9530ca0a9fb2f155105cec63965028b5b045e3b2fa8928c"
    sha256 arm64_ventura:  "46009b3114243c1b11085877e3bc771160111652ce3cb2950c72a9aaa2702dd7"
    sha256 arm64_monterey: "fe8d835568ec1832842b1dc9978812269c5ae41bfa678248c2ef5e9ef6db4ad0"
    sha256 sonoma:         "a5c470008848cd9d62c02f55c224fcd5e5fe40d6b4c7136c96d7586080ccb514"
    sha256 ventura:        "4943e0cc391ff8084187ffe9ea92b3cd2e106faf5a1ed677603ac52f14c5b8a1"
    sha256 monterey:       "adeb0d50a0a2f865bf3353264edbbb44b79d9e366aab4a883317264f26408ad5"
    sha256 x86_64_linux:   "8fc76e69f070f3bc6353479a850ad4cb6884c182bdd1b998624a76c880a10d34"
  end

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "pkg-config" => :build

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

  def install
    ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].libexec/"lib/perl5" unless OS.mac?
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
