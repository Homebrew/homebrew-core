class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v5.7.0/qalculate-gtk-5.7.0.tar.gz"
  sha256 "dcb3663b36abafdfe32e943644bf4fc64bd685c0225f944a3f1c4a85e70db3b5"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:  "15bde61f26fa00d26cf9863d7a78a34239e25b3818466b101a37b882fae3605d"
    sha256 arm64_ventura: "4af623c2b0a434da474d072f5ae0d277799022b64167d1363768c2be6228fdb7"
    sha256 sonoma:        "8d82b164a2bfd123f543882c916b3493648dd15030aae95ba143b4cc85aae73e"
    sha256 ventura:       "2a9cf3014005d73f22a5258e8f5fa251b1c3b934b9534d8636e6d390a78b61fe"
    sha256 x86_64_linux:  "35c3ec2b11808358c7e0b8147f216c14934367f3d7771a1cf2091b009f9a34c4"
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
