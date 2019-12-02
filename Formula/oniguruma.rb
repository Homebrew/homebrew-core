class Oniguruma < Formula
  desc "Regular expressions library"
  homepage "https://github.com/kkos/oniguruma/"
  url "https://github.com/kkos/oniguruma/releases/download/v6.9.4/onig-6.9.4.tar.gz"
  sha256 "4669d22ff7e0992a7e93e116161cac9c0949cd8960d1c562982026726f0e6d53"
  head "https://github.com/kkos/oniguruma.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "06193af02210587ee2b6d63fcf5f18fda46ba84cb21143b5f5b12abb456ff3ec" => :catalina
    sha256 "ed28f2729bacc662f624254a442a90219ee885a8ef1c9241542c4a8ec55c15b9" => :mojave
    sha256 "4dc26cf4626173982cca426a550d1554416d099505537666da01fba148aa8f13" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-vfi"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match(/#{prefix}/, shell_output("#{bin}/onig-config --prefix"))
  end
end
