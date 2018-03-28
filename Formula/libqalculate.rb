class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v2.3.0/libqalculate-2.3.0.tar.gz"
  sha256 "29335b91b5215dcc384396343b03b2bb99cf4e827b7084f84ac32e6a09661796"

  bottle do
    sha256 "304f896d1bf0a0d7beb3d2070586cb6d6f71be4dcca0255c0cd0a8643bd9a4f8" => :high_sierra
    sha256 "3ec1472fe6d2701b12a6988661066e83f6f3f9fdebfa862b25754a8bbd571b7c" => :sierra
    sha256 "251050e92389842a1887f12e02f6e9af63b712f39e7f4e5bbd18b8fcccdbd712" => :el_capitan
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "cln"
  depends_on "glib"
  depends_on "gnuplot"
  depends_on "gettext"
  depends_on "mpfr"
  depends_on "readline"
  depends_on "wget"

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
