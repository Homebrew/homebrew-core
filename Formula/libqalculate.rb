class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  # NOTE: Please keep these values in sync with qalculate-gtk.rb when updating.
  url "https://github.com/Qalculate/libqalculate/releases/download/v3.19.0/libqalculate-3.19.0.tar.gz"
  sha256 "43657a96e18b91739a0ef1d0f42701d7c5a0c8a3a6c7eee8ebfe9aeda75f7ddc"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_big_sur: "911a3c8dd1c9020f50b187d9f95d2ad36e3e42b4366644ff4fa3d8d70aa0f6c6"
    sha256 big_sur:       "990c86dac258007cdb44890d5a1544f937dd643685b671ecdb5f471c29037dc3"
    sha256 catalina:      "a5465ed0cb0eb6c18fe2405c27c2251e2263d820deccdfba51a6169b45ca8358"
    sha256 mojave:        "621b1383db3e61cc9e0ba08bb30985579025bfe18aec1b5f2c3a36f37dbcbf3a"
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
