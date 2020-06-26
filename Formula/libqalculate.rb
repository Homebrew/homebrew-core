class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v3.11.0/libqalculate-3.11.0.tar.gz"
  sha256 "6992ff25774a15d6a0b09542b1f137dd5dc00995dfe9a765205ec2da39b4e13f"

  bottle do
    sha256 "843ddd060eecf788a780689921a6c52c1f1f90aa6fcc70ff44eef4dd3ed22633" => :catalina
    sha256 "497eb71777218e73ec8f6f35934912967f32e1f5840a1ec333da68f63e439959" => :mojave
    sha256 "a5d777a2992d265c4fa7ddeb056b509c8a80cce3b381a4b12f6d04d4925c0df6" => :high_sierra
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
