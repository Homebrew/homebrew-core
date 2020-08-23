class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  url "https://github.com/Qalculate/libqalculate/releases/download/v3.12.1/libqalculate-3.12.1.tar.gz"
  sha256 "28c46dc8dd975f253627d80c55a6feab7c44d965dce3ceffefc3cafc9a97c457"
  license "GPL-2.0"

  bottle do
    sha256 "4b449d035cbccbc76d5d39c7a601b162df5f7fae5c9f0a67624513d1e48db92d" => :catalina
    sha256 "737229c55c1f26c4d22c87cf4dde6e1beb51760e1735d6386303096847680d8e" => :mojave
    sha256 "975a77ca0bf73190e872edcd2ac0feb78bcec8f707f3ce07c88e23ade92ee8ba" => :high_sierra
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
