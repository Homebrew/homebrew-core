class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v5.5.0/qalculate-gtk-5.5.0.tar.gz"
  sha256 "89840c16deba524b23512dc6d8d91f74f282c672a2ad001533f4b063d49171dd"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:  "426275e82a8cb94db7738483637564642d56634409eb386fdbc51a13fd95017d"
    sha256 arm64_ventura: "90fa6b76760deccef0bb2f7f027ebcf435c0ae8bc5df26bde45af50d6b4559e3"
    sha256 sonoma:        "4d9816c839a211ec5d7b703ac15b60aaf0da3b39217a3db964ba653cc21a5bda"
    sha256 ventura:       "55a991183328bf4a13497b27a01a3117e8acf0ebc92e9efb059fa63ede6d9802"
    sha256 x86_64_linux:  "4e1367935fdde11c2471c6a44640ff339ef2a0dd6fe47c792e1f6747d5f8300d"
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
