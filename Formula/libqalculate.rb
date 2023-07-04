class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v4.7.0/libqalculate-4.7.0.tar.gz"
  sha256 "16135bcd07a905ffc27a3f1abe5e6feb6cda6c40e5f6bb35127fefdb50ccfd02"
  license "GPL-2.0-or-later"

  bottle do
    sha256                               arm64_ventura:  "264861d918ae500279561e2279469526c029e78f5849de158d6e4761d1d71e84"
    sha256                               arm64_monterey: "68a04bdd22cfa4630b046ba28bc71816a39b01e777aab158d4122d5617174c13"
    sha256                               arm64_big_sur:  "27eb633daf249725d1672d15a304b0a4e9ce3a6a83b43985161b8317fa58b1c6"
    sha256                               ventura:        "16c3346024abe2b162530435de8f3f11f49ff5f68f9d5909727c84805442e319"
    sha256                               monterey:       "1f113f17d6ee9925c9c1d977904f283ee96f8792ed4403563aa7b5cb5fd891fc"
    sha256                               big_sur:        "9404c5f8102e18f011d4803bb2e78b33cb976e1154e2f06621dc0e3b5968ad8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2384b5b8a820bac5287a3de932dc993b8fd9e9484706f64435987d8001e14aae"
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnuplot"
  depends_on "mpfr"
  depends_on "readline"

  uses_from_macos "perl" => :build
  uses_from_macos "curl"

  def install
    ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5" unless OS.mac?
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--without-icu",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/qalc", "-nocurrencies", "(2+2)/4 hours to minutes"
  end
end
