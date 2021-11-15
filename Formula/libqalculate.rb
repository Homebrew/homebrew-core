class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v3.21.0/libqalculate-3.21.0.tar.gz"
  sha256 "2a2b6f8de4b43acdff98efdda338436db1a3f7ecd994e1bc2a422a65fba03479"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "474bd715cfef115d357e6c5b42937ac31ec6d610d726ed433a166fbe5df27b46"
    sha256 arm64_big_sur:  "c5fa566c1bfcee52df79e2b352c851d06e35a6d62cb5e173f468d1db00196236"
    sha256 big_sur:        "3691489924b0d10808f7b28f2a9a5144e1695195fe9af5fb18cc6cf34aa9902e"
    sha256 catalina:       "8fe96ee96986175d97ae18b9e10ed75712f28f7a43167a120d1e9fd5eb42e598"
    sha256 mojave:         "1c11025d7abd80744bc4077822571c77db47d6999e0ad7c5957ec1a87272bb5c"
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
