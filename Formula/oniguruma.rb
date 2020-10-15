class Oniguruma < Formula
  desc "Regular expressions library"
  homepage "https://github.com/kkos/oniguruma/"
  url "https://github.com/kkos/oniguruma/releases/download/v6.9.5_rev1/onig-6.9.5-rev1.tar.gz"
  version "6.9.5-rev1"
  sha256 "d33c849d1672af227944878cefe0a8fcf26fc62bedba32aa517f2f63c314a99e"
  license "BSD-2-Clause"
  head "https://github.com/kkos/oniguruma.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+(?:.(?:mark|rev)\d+)?)$/i)
  end

  bottle do
    cellar :any
    sha256 "15241cccbb727a11200b6eb7398500795057bb065784a3af6ec9c98cd6ce7686" => :catalina
    sha256 "40fd839d421fba70280c0b6f879c4a5889205e4ba2292a568df935dc410fecb2" => :mojave
    sha256 "b522dc58b0b37db5102213150acd1ea740c201d489d65d6a3b63cced744acf6c" => :high_sierra
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
