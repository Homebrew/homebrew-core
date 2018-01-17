class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v2.2.1/libqalculate-2.2.1.tar.gz"
  sha256 "1752b6a046eaf84ee62a7dc8d2c874b538517956ce8affac80df09a3b55bef5d"

  bottle do
    sha256 "e455697faa05f863edcd3d4e528c20be8ae2a5b93e7c3d59c574794562de8f2d" => :high_sierra
    sha256 "a068486e78a0907adcebe3697a999471894bbd8718c117415e625f960d9337fd" => :sierra
    sha256 "d0998716203567359bc7493adf00e82af212d66334ea1fd2028ade0ae14aa75b" => :el_capitan
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
