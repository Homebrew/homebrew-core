class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v2.8.0/libqalculate-2.8.0.tar.gz"
  sha256 "b18f594894135e96121b1f81b341f05582ac73fc53680b6e35063623ceea6262"

  bottle do
    sha256 "b02cc4649d845a31cd9137944100675a718d5098162d55760c467135785292c6" => :mojave
    sha256 "6f8113d0328564c0e286139fa61b6c5936ed6d6274ea9c9fc3a1f33f602c35ae" => :high_sierra
    sha256 "0bd109a8052d537ed0ae5037faef021644481a1cbd526468c227b84ca3c33867" => :sierra
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnuplot"
  depends_on "mpfr"
  depends_on "readline"

  def install
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
