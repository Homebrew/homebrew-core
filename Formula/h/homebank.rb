class Homebank < Formula
  desc "Manage your personal accounts at home"
  homepage "https://www.gethomebank.org/en/index.php"
  url "https://www.gethomebank.org/public/sources/homebank-5.10.0.tar.gz"
  sha256 "783fd8bb2ebba09713e5d7c183d454f4a4393e828af5763f768b48afabc54386"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.gethomebank.org/public/sources/"
    regex(/href=.*?homebank[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "aee02dc3fff432117ece240c1eaf45c01698a96cc7b56526b6c36370f6aed519"
    sha256 arm64_sequoia: "a7de2cf81bb1f9ec967095a62de4f0156315670399bb5ea29dbabb9bbd93b99b"
    sha256 arm64_sonoma:  "4bde5b38338f1e4b5ad88e6f19321c8f3bd45d34a19e4d90ea046e015da70ff3"
    sha256 sonoma:        "fb96d22c3544f1468447fb8aa6bf32d4d1a05d188a5bc51261d6e59b358d4c7b"
    sha256 arm64_linux:   "a1b95c04cd7c6d3f41eff4866919b92313f0b1b7874d528187e81b14c66fdaea"
    sha256 x86_64_linux:  "4a1c4fe05561650143adf5bb451e1aa28e35e199f2519636d4ef42c12b36b1f8"
  end

  depends_on "intltool" => :build
  depends_on "pkgconf" => :build

  depends_on "adwaita-icon-theme"
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "libofx"
  depends_on "libsoup"
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
    system "./configure", "--with-ofx", *std_configure_args
    system "make", "install"
  end

  test do
    # homebank is a GUI application
    system bin/"homebank", "--help"
  end
end
