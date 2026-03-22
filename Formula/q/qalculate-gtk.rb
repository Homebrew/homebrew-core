class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v5.9.0/qalculate-gtk-5.9.0.tar.gz"
  sha256 "39cd0bc5abe26edfc04a3064d4412d5af9f7197eafa0762a18a0cb6996f1021b"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "0f1c553a5720ca93fa4e7965717f9399f24192740a9b6a3f31ad8c08d6321b58"
    sha256 arm64_sequoia: "8e74563d4bb679b2c38c2180ca1c7337192b47c01218c6b72ad364c9b950b293"
    sha256 arm64_sonoma:  "fa5e580d73a86b8b53712b272c1096057517206308dffb2a2616ade98e4e0a8d"
    sha256 sonoma:        "37609ce87250945892d1944b91d0d95d9ec4ef3fdc275531cfa30303c592aaa4"
    sha256 arm64_linux:   "cc607df50c4c5a7708520ea49c4a3a0176ed5ff6a464bd2b6afedadf842bf623"
    sha256 x86_64_linux:  "b2431e7fc908b3539d604537a12458fe210d073085db22458b60bf0dc75b2a96"
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
