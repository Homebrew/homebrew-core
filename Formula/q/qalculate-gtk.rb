class QalculateGtk < Formula
  desc "Multi-purpose desktop calculator"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/qalculate-gtk/releases/download/v5.13.0/qalculate-gtk-5.13.0.tar.gz"
  sha256 "2c6c9711fcd1bebb09b27c39dda9bd6e0a86b1b17b1538b4e9a1c711e435a830"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_golden_gate: "594b279dce56c32b5c26aa0aabdc55a284becffc7b13039ef6f9c7cbff1a765c"
    sha256 arm64_tahoe:       "b9d272c40cde50b5bf17ccbea3ade31871b65d9747a688e3a4e120447a50d24f"
    sha256 arm64_sequoia:     "8c9d7f256ca51b722fefb05eb5b4fddc981fe10598d41cb35d824471f6c5bc64"
    sha256 arm64_linux:       "d3358efc075596045efeeac4b7f461f1cdf28a7ff78fddb2cc81aa6b6dcf6071"
    sha256 x86_64_linux:      "e0f930994f5c745d1102c7d1dc59aac1ddb1b1de1c5dd9f5cc28b047d8e003fa"
  end

  depends_on "gettext" => :build
  depends_on "pkgconf" => :build

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libqalculate"
  depends_on "pango"

  on_macos do
    depends_on "at-spi2-core"
    depends_on "gettext"
    depends_on "gtk-mac-integration"
    depends_on "harfbuzz"
  end

  def install
    if OS.mac?
      ENV.append_to_cflags "-I#{formula_opt_include("gtk-mac-integration")/"gtkmacintegration"}"
      ENV.append "LDFLAGS", "-L#{formula_opt_lib("gtk-mac-integration")} -lgtkmacintegration-gtk3"
    end
    ENV.prepend_path "PERL5LIB", formula_opt_libexec("perl-xml-parser")/"lib/perl5" unless OS.mac?

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"qalculate-gtk", "-v"
  end
end
