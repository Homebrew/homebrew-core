class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v3.6.0/libqalculate-3.6.0.tar.gz"
  sha256 "66b38ed6460f0cd6a1b16ba4145c0396c995939da0ed78f15736f8cd794969b2"

  bottle do
    sha256 "6aa37a0ac5ed476c10810a237a65409d37179a987abf0759dd570b0f06b91608" => :catalina
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

  # Fixed for next version: https://github.com/Qalculate/libqalculate/issues/167
  patch do
    url "https://github.com/Qalculate/libqalculate/commit/6f1aae9c.diff?full_index=1"
    sha256 "3df223259f3925345ed0ebe40a659bbd146f940f54972ff45852d8959a50f62b"
  end

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
