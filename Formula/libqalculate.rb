class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v3.4.0/libqalculate-3.4.0.tar.gz"
  sha256 "752d975c3e2cd3ff5827fde5f6d4554a2e5c436826ba8af9cb0623f82615dc60"

  bottle do
    sha256 "d80e8dc8831a96ecf6cc8df65dad62428a552f2755edeb19c4bd9636d9badff3" => :mojave
    sha256 "74bfd3a79c11d365da4e65c6afcecc0417ce487f6dab1355d7dcfae296204dd1" => :high_sierra
    sha256 "9e4661c61714b98d80cbdd680972a1160bf213eb10c6bc6c643d51c37e520daa" => :sierra
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
