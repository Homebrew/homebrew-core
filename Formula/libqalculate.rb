class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v2.8.2/libqalculate-2.8.2.tar.gz"
  sha256 "12c41d9a56c89240d8f0e39cac98e66703c620b3a08cb6f39d54193199534a51"

  bottle do
    sha256 "1f5eead17b3bc180b0209fed9c80265e0fdae48e33de6f16d1db1d5d424515c9" => :mojave
    sha256 "3d0fc6418b5a58d77f23b4e2f16f68246ada73e4237a4c03b0b1e7a6b81afdc7" => :high_sierra
    sha256 "3acaaa2388238e247e002093b65e487765da6af3b0a8d08242c5a83ce2affe26" => :sierra
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
