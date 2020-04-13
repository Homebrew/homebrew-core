class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v3.9.0/libqalculate-3.9.0.tar.gz"
  sha256 "d9d219e74314f863811763be0518f05362dc0b084222728786d8639fadce37dd"

  bottle do
    sha256 "3554e5419aecc4ec6f910c8dd83283b08771aff982694ade05d89116b364499a" => :catalina
    sha256 "9c13d2e2d86553f4f50f7097b9dba60662d7a3ecb916245650eea25914ecec3d" => :mojave
    sha256 "810f043cd13cdf704175764baf40b9a5fb5529d15d924fa6ba364efa97f2b2a9" => :high_sierra
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
