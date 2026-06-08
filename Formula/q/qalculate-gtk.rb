class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v5.11.0/qalculate-gtk-5.11.0.tar.gz"
  sha256 "529854fc5a3bd62a1a0e814879c576668b238604c5b2cb2c422979aeac355927"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "0bed933c3d673bb6d7cf78f3fe32cd13e8527ec0d98bc72db57caec4d3a1b97a"
    sha256 arm64_sequoia: "3c020f7a6809689f9b6645a0b9c83ddb23c973917fe2d6fa042322d2e6bd2666"
    sha256 arm64_sonoma:  "403682668cb01572a3c7ff5f44e4e3767e82968da48d731124560f5aebe8d214"
    sha256 sonoma:        "ee29fcc2a45f82700fdaa9caa2ccca40f31790c6fe1fd8127c71cfb8d14128c4"
    sha256 arm64_linux:   "2bdcd8dfc5d20ef89d995a84829549e58d6f018f178d34cb72ef2834ceefc07a"
    sha256 x86_64_linux:  "070968efcbf14e2ba699703130c7ea94a367ad3c6c830db244b4025f87984ddd"
  end

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "pkgconf" => :build

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libqalculate"
  depends_on "pango"

  uses_from_macos "perl" => :build

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "gtk-mac-integration"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    if OS.mac?
      ENV.append_to_cflags "-I#{Formula["gtk-mac-integration"].opt_include/"gtkmacintegration"}"
      ENV.append "LDFLAGS", "-L#{Formula["gtk-mac-integration"].opt_lib} -lgtkmacintegration-gtk3"
    end
    ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].libexec/"lib/perl5" unless OS.mac?

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"qalculate-gtk", "-v"
  end
end
