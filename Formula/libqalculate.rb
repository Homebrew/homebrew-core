class Libqalculate < Formula
  desc "Library for Qalculate! program"
  homepage "https://qalculate.github.io/"
  # NOTE: Please keep these values in sync with qalculate-gtk.rb when updating.
  url "https://github.com/Qalculate/libqalculate/releases/download/v3.18.0/libqalculate-3.18.0.tar.gz"
  sha256 "ed7263f48d12a1dd94fe105156a6563125e9b3fe6361e9a9deb5b0ea5cbf03cf"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_big_sur: "7882399b2b27b9f53b68e18c4af09051cdfc206500429076650c93a167770f04"
    sha256 big_sur:       "ea4e1efcef519b31fe52a66a8792ce336fb215ba89ec058092b5775f4dfd3b8a"
    sha256 catalina:      "7c859a9980485fbbad44c8aeffdfc99b9bddc36cadc3fde6dc73a30b2ed7c604"
    sha256 mojave:        "c1d89bc359e271695cf0853d7d17ed4139fd8bb9d42fabe88423c230ff1cd64e"
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
