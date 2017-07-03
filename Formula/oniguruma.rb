class Oniguruma < Formula
  desc "Regular expressions library"
  homepage "https://github.com/kkos/oniguruma/"
  url "https://github.com/kkos/oniguruma/releases/download/v6.4.0/onig-6.4.0.tar.gz"
  sha256 "cf43ddc5167aea260c4297c76b0dd5e1e6d67aa39319db667347d4d0706ff695"

  bottle do
    cellar :any
    sha256 "209e25514cc15d9a6cdee988050dd19b900152a93dc282f958e1d057e97bbe57" => :sierra
    sha256 "8a3df7900d2a260668bc1ce383a1d7ecdebb36b767511445de907fa16c6e750c" => :el_capitan
    sha256 "997799104ad17018f56b2f98c4d47ea19cfbb31da06b50e33137f0b878c45608" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /#{prefix}/, shell_output("#{bin}/onig-config --prefix")
  end
end
