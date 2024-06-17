class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v5.1.0/qalculate-gtk-5.1.0.tar.gz"
  sha256 "173339cce04a6f0ba4c56c233987a30188ef10170da7cc545a8876c3d5c42185"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "3f7a20ce962c0672e36f2ab21953d1e725b2f4888792e01c2301771ddd640578"
    sha256 arm64_ventura:  "3170c5af9a2e1916c00e86888965fbd8ed8ad1a49eccb1158395a102c2f40916"
    sha256 arm64_monterey: "3b705a61dbe8c90b292e93fc3269878008f2d61f1110b50f1670411e7390646e"
    sha256 sonoma:         "e9cf64425ba38b737407a3d92807a0abdc4f3c871f06ed5e919cca18257ff678"
    sha256 ventura:        "e75a99422c10c4aa6abb1567fec48cd294cad645f14227d4a6150a8638307ead"
    sha256 monterey:       "164a0586cb61894f7f0c1b3fbd5d7130e25fb89cc30f8f88d90aed1703d67325"
    sha256 x86_64_linux:   "5615344ad63031becc28a365cfec4d728031c60fcad3fce80f353b830bcfeef9"
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "libqalculate"

  uses_from_macos "perl" => :build

  on_linux do
    depends_on "perl-xml-parser" => :build
  end

  def install
    ENV.prepend_path "PERL5LIB", Formula["perl-xml-parser"].libexec/"lib/perl5" unless OS.mac?

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/qalculate-gtk", "-v"
  end
end
