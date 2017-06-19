class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v0.9.12/libqalculate-0.9.12.tar.gz"
  sha256 "4b59ab24e45c3162f02b7e316168ebaf7f0d2911a2164d53b501e8b18a9163d2"

  bottle do
    sha256 "2c2e4e9a9948111cb7281225d7eb55a62b19540c95cb1525495871452e9a8d3c" => :sierra
    sha256 "f41994adf6c16077f4ff82e6efa3ab03f21ef3c26180e7fcb24bcd49ad03e4de" => :el_capitan
    sha256 "56870b47784e7947d47070b3afb863e3fdfb1eafe9b2f8add68628e1a55a1096" => :yosemite
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "cln"
  depends_on "glib"
  depends_on "gnuplot"
  depends_on "gettext"
  depends_on "readline"
  depends_on "wget"

  # Fix "error: typedef redefinition with different types"
  # Upstream commit from 9 Jun 2017 "Remove clang build fix"
  patch do
    url "https://github.com/Qalculate/libqalculate/commit/63c6b4f.patch"
    sha256 "47d2f3233d104eb591cb16c34648e163a99a85d240661eacb5a8f3ab5d4fb268"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/qalc", "-nocurrencies", "(2+2)/4 hours to minutes"
  end
end
