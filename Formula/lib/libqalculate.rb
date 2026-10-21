class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v5.13.1/libqalculate-5.13.1.tar.gz"
  sha256 "cf8d3eaf3d85030115701e997b6585e69573e71add88e7758486c5d1b01d3cc3"
  license "GPL-2.0-or-later"

  bottle do
    sha256               arm64_golden_gate: "6af799ff6771bf5602443dff16199c0b77e2be24613d4ebc5558194448a4301d"
    sha256               arm64_tahoe:       "0f88adedbf0753257f8c37f46d3095f213b0d3f6e458ce530723cf92fae7e539"
    sha256               arm64_sequoia:     "800fcc87061bb7b89ff9fdf90539623c9118a48486f5b2024a2c76527002293d"
    sha256               arm64_linux:       "483803ca803cce78553fa36570da21dba7617ebbf8f3bcf93814bc77336aa275"
    sha256 cellar: :any, x86_64_linux:      "4d0763979036d2e8606260cae8699e6f41f568f95ee419238303ff3fe94cdb5f"
  end

  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "gmp"
  depends_on "gnuplot"
  depends_on "mpfr"
  depends_on "readline"

  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  def install
    ENV.cxx11
    system "./configure", "--disable-silent-rules",
                          "--without-icu",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"qalc", "-nocurrencies", "(2+2)/4 hours to minutes"
  end
end
