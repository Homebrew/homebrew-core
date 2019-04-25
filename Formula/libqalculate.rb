class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v3.1.0/libqalculate-3.1.0.tar.gz"
  sha256 "40174309c59a0eebdc42d63b230662d8b897bee21a6a31f10d7387b17b133a11"

  bottle do
    sha256 "93207eb981c562425c9f3da3d933a544aa45c0be3ae81a3f3e4d32fda26c8e16" => :mojave
    sha256 "5d94d244ee0c379f0345f2854f2378bb4f50470727e2c6a5bb5d3b7e411575a2" => :high_sierra
    sha256 "1e32581a07f0a1bbd85a281f7e2e6bffc7670926dc65d29e4a428efe18f8be3a" => :sierra
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
