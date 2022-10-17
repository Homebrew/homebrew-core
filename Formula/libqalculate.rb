class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v4.4.0/libqalculate-4.4.0.tar.gz"
  sha256 "79cfdc4d4af9dfcd6902c2ec680ed1f3d5845d07b5ee1c76255fdca731a8b758"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "063f56475c7cf88d75222e92529cf30f806dd8b176b17fa1f9863762a5c87e70"
    sha256 arm64_big_sur:  "e3a0e1489a915168929c712f5f47f13791b459dbe1dcd3dc5f4c5154153901e0"
    sha256 monterey:       "2822f8ab733847547aedadafc7376185eac0b04379ea0e26fb86d6578e040ad5"
    sha256 big_sur:        "8e039b824d39c423521c074febf1e6f1908abbf0a6140e65dfe319bac0ce3bfb"
    sha256 catalina:       "7f7387cd3c91f0681c9998ef2e851db8ae90cd9d8d7d9bd7e04a8ddb4e9f4df1"
    sha256 x86_64_linux:   "4a5b633c42b8805e98ed7600def06ebecf2d0e593caeb10ae298957ebe377ff6"
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
