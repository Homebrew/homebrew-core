class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v4.1.0/libqalculate-4.1.0.tar.gz"
  sha256 "d943e5285bdc0b3cd77b8f7a10391d7c753fc19b0ddd48e5d4179decf709d6ff"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "8dc382a92e7576d2759f1221edbe700be0f35c5bdcf04c090bf1eeede54919e5"
    sha256 arm64_big_sur:  "a7432784871c69b39bf020a67ad1a54da501c18d39fbe81c181b0a07376f40a4"
    sha256 monterey:       "3c8f1def4eff72d19b079f7468e301e292c0b26b855b38128b09767f1a754af8"
    sha256 big_sur:        "3d4dd5a0685bf6853624648432dbb6d24a9ad060585358e63161a810c292d309"
    sha256 catalina:       "2da6f88c87a8c2e75e67065e4efcbd6b035bf9ce7b2f4bfe11b6fb12cf118dad"
    sha256 x86_64_linux:   "4d46f33bfc53d6daad6adf99248c5366e74670351e2104fde60a1427b4a6b310"
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
