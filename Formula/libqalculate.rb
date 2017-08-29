class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v2.0.0/libqalculate-2.0.0.tar.gz"
  sha256 "86d04362f37aa5acbc78108e0044b96fbffbaa33c309c19c8c37ac4fb46c5485"

  bottle do
    sha256 "cfef7cbb714bef3f00d317a92fd45f2e4d1356e7f6f3a2a852beefbeb83f52c6" => :sierra
    sha256 "dc29c0ab4993ff54d6b53a142547147622646fba99dc5aa5aac5475aeb4c77e7" => :el_capitan
    sha256 "abdd1944a9d09bafa153abcc704ec63f91fbd264ecb6e744279636a5d7cac93d" => :yosemite
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
