class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v3.12.0/libqalculate-3.12.0.tar.gz"
  sha256 "ff6b56c2afbed4c37b37869fde3b45610722fa4bb4b802c84f7cb387968fbc68"
  license "GPL-2.0"

  bottle do
    sha256 "dca1ef2a4ab82c30e04ba6dc2f0b63708dee3bf46269743ba12fcbd2ad695922" => :catalina
    sha256 "5018fea9dbe349aaa1ce14136560889670f91725b2f34b15610dcae1782f8af7" => :mojave
    sha256 "31dc53b3702591f3fef267b88baae6bfc1a969694dd778ebad53d3d1c6d749a2" => :high_sierra
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
