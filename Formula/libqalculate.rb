class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v4.6.0/libqalculate-4.6.0.tar.gz"
  sha256 "07b11dba19a80e8c5413a6bb25c81fb30cc0935b54fa0c9090c4ff8661985e08"
  license "GPL-2.0-or-later"

  bottle do
    sha256                               arm64_ventura:  "711c7cb35977d3a8468a8be0bba3ce4e087731e8adc3401b1f948250088d6aa1"
    sha256                               arm64_monterey: "93032bc440ab8f0a9fdb0f7fab995185003530c83dc470ac8993cdd2835a736f"
    sha256                               arm64_big_sur:  "a6aac017daf1943ba30eacbf5bc455a33d743b2ba4011b9152ce0087f90de3c2"
    sha256                               ventura:        "3d6271e27548f2e6a5a4fe26c965b63f3e8c13882557554f4eb99e7353c7cb8a"
    sha256                               monterey:       "2ac0ba8e20232ed4dada0eea1affacc2549f4498efbbde3a791f9127d3fc7195"
    sha256                               big_sur:        "3685edee09e9c4fa6eb0c15bc254347af81a0e3237f684dd623e9c4adb8ffd4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ebe23c37326c84bef11c3b027a5eaac8ead5f717599cdb0ad150384362fcf2d"
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
