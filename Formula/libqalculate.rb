class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v4.1.0/libqalculate-4.1.0.tar.gz"
  sha256 "d943e5285bdc0b3cd77b8f7a10391d7c753fc19b0ddd48e5d4179decf709d6ff"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "94cfc754a3f82039c24a7438fb060615f38428d0e765e28bbecf47964cab0f95"
    sha256 arm64_big_sur:  "f8f4df3fe84120fd30ee89176f52c48db4149166ae0a0096b3e9f00387906afc"
    sha256 monterey:       "863c4c1ac56c73210d41bf7f9621de281f1303d8222028be5bb0a58e7e708815"
    sha256 big_sur:        "b37c13c6a799cecf2904b9f3ca68ebaee386b12da7ca6cf11a41d097f6ec7852"
    sha256 catalina:       "1237bc763a1519d58e2c9526ddd43ecabfae09113a509e602a4442ac56f8d5c6"
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnuplot"
  depends_on "mpfr"
  depends_on "readline"

  def install
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
