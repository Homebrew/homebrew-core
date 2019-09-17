class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v3.4.0/libqalculate-3.4.0.tar.gz"
  sha256 "752d975c3e2cd3ff5827fde5f6d4554a2e5c436826ba8af9cb0623f82615dc60"

  bottle do
    sha256 "0c1230dd9c4fb171ded973f79d14a49bb1e5f7bf83286e7135c65e4966c9f089" => :mojave
    sha256 "ada6a6f96f93932f09bfa499f83a322b94e0cc5fc3bdd9b2f5c9f7fa857098fe" => :high_sierra
    sha256 "93c4e82a2186a90ed2e801cbab0cc6625a4f48f0cb6e498a2325f4a39a04b9b1" => :sierra
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
