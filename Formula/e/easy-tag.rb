class EasyTag < Formula
  desc "Application for viewing and editing audio file tags"
  homepage "https://wiki.gnome.org/Apps/EasyTAG"
  url "https://download.gnome.org/sources/easytag/2.4/easytag-2.4.3.tar.xz"
  sha256 "fc51ee92a705e3c5979dff1655f7496effb68b98f1ada0547e8cbbc033b67dd5"
  license "GPL-2.0-or-later"
  revision 12

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "fc83e82e1bf16cb52d433688b8c8b89374c2d09027a453745e57ca27ee5b3b4d"
    sha256 arm64_sequoia: "f79b0ed3c4026cb1c8019b60bd0ecb5bf466b14e758a70cb4e35bb6642e45c98"
    sha256 arm64_sonoma:  "86ea6ba733c44dd73aca5ca7e079f66abb42fe26d24371ecdbfdf033097a1867"
    sha256 sonoma:        "7fd6763ed03295537a80d52a0615315a153deba9adc12c8941209e5bcb5f0f68"
    sha256 arm64_linux:   "6c65815c229b68fce8e0868f31f09e8f787138b0764dd8b6df6ca04d6bfbdfbd"
    sha256 x86_64_linux:  "81e667327978a857d545aae15b4e03ad2f4a0e06cc73e224b1cc8bf561bb5e10"
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
    # id3lib's headers break under C23; taglib 2.x requires C++11
    ENV.append "CFLAGS", "-std=gnu17"
    ENV.append "CXXFLAGS", "-std=c++11"
    ENV["DESTDIR"] = "/"

    system "./configure", "--disable-schemas-compile", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  def post_install
    system "#{formula_opt_bin("glib")}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{formula_opt_bin("gtk+3")}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    cmd = "#{bin}/easytag --version"

    pid = nil
    if OS.linux?
      IO.pipe do |read_io, write_io|
        pid = spawn(Formula["xorg-server"].bin/"Xvfb", "-displayfd", write_io.fileno.to_s, write_io => write_io)
        write_io.close
        ENV["DISPLAY"] = ":#{read_io.read.strip}"
      end
    end

    assert_match version.to_s, shell_output(cmd)
  ensure
    if pid
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
