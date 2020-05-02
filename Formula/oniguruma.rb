class Oniguruma < Formula
  desc "Regular expressions library"
  homepage "https://github.com/kkos/oniguruma/"
  url "https://github.com/kkos/oniguruma/releases/download/v6.9.5_rev1/onig-6.9.5-rev1.tar.gz"
  version "6.9.5-rev1"
  sha256 "d33c849d1672af227944878cefe0a8fcf26fc62bedba32aa517f2f63c314a99e"
  head "https://github.com/kkos/oniguruma.git"

  bottle do
    cellar :any
    sha256 "d38309153631f9087a3eeb3493e56b414f5c9178172f08d4cb70e7ad7e570509" => :catalina
    sha256 "b5313539e2b51100e1e9c98672a41cb58bdb58c34c09d7227678eedfef4949c5" => :mojave
    sha256 "c1de50154e3ae86545e8df69efafa1e07a03e8171e0215b863179f3ea6f8a2bc" => :high_sierra
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
