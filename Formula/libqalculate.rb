class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  # NOTE: Please keep these values in sync with qalculate-gtk.rb when updating.
  url "https://github.com/Qalculate/libqalculate/releases/download/v3.16.0/libqalculate-3.16.0.tar.gz"
  sha256 "d21445af45f2df241b191717c5a29fb93fe4fa938ea23bcc0d322d53f6f42327"
  license "GPL-2.0-or-later"

  bottle do
    sha256 "84f7dda0cf6c217da6a10e0264fcaf55d1f496f0360d05c807fc546cf4caa633" => :big_sur
    sha256 "8f3f3d611fc17ac3adf2ffcb12e7e73981f75586ea42905ae2860dea1120e40b" => :arm64_big_sur
    sha256 "1dcf5abe5fa1cb7f773460119228aec96c72305bd26031ca03be9c6a471e89d3" => :catalina
    sha256 "acac62df2acfe4dbae36ca58edd8e7e99abb6efcc3b58d92f0d0df267d08b74a" => :mojave
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
