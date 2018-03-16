class Oniguruma < Formula
  desc "Regular expressions library"
  homepage "https://github.com/kkos/oniguruma/"
  url "https://github.com/kkos/oniguruma/releases/download/v6.8.0/onig-6.8.0.tar.gz"
  sha256 "c9cd7b50f96460a8f5823f5916f57038c24cfb0d8e3bb86b8bb8b990daa4755c"

  bottle do
    cellar :any
    sha256 "6d78e3d91c76bdb1c9012dc62b296de123fd93d15d65787477451df4c852dd08" => :high_sierra
    sha256 "5027a5481ca681b9ee68b39ef658cfef2c5d67887b75ebe232c1fa8bb1d38d2a" => :sierra
    sha256 "c75abb9e9f12c390f32cfb99a6248c5201e0ba28dfab94fce1f2c7da7adbd926" => :el_capitan
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /#{prefix}/, shell_output("#{bin}/onig-config --prefix")
  end
end
