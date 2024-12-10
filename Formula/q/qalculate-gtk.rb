class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v5.4.0/qalculate-gtk-5.4.0.tar.gz"
  sha256 "9a112b3bcb348834dff631fa5d8a55f36b0e4caf5d992c21e4b1a72879611331"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:  "0bbed3a7751d952ba081966830aa6c1244a5eab9d16b5bdaf8f7fc9b6064ebb3"
    sha256 arm64_ventura: "288af7fe2d06a2d8973a83b879b025850f7447629833b6a50b285bc26ddd0cda"
    sha256 sonoma:        "22a49f59a963fca47e7710711353c24817b69c549382b77e0a9d0a26165a0b05"
    sha256 ventura:       "9a3cb7637233a80c6c6c61265fa99c0ead25b4381e42186e6fb96d783c1fa302"
    sha256 x86_64_linux:  "97c8bd229a1b196064d3cc5dcdbbc3fef66ff8e11163b1e6c537958b5fa5ead4"
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
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].libexec/"lib/perl5" unless OS.mac?

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"qalculate-gtk", "-v"
  end
end
