class Oniguruma < Formula
  desc "Regular expressions library"
  homepage "https://github.com/kkos/oniguruma/"
  url "https://github.com/kkos/oniguruma/releases/download/v6.7.1/onig-6.7.1.tar.gz"
  sha256 "81ffafde8f34e6e692c57ec654bf9716ae9b35828ffcb787399259fc0d5564b4"

  bottle do
    cellar :any
    sha256 "577d595fce96056893075142ca5b2b27eb1bffa222e3c764da33859d84de2d6f" => :high_sierra
    sha256 "6bed9c7285ef0d2d2683d2817297e8ccaf17e9cfd3ffefb6e48c30bdea9ceaa0" => :sierra
    sha256 "0f8c5ff26eb18ea0966570bac198b730dbc3178ade9655f9ae9fd6b6bca867e9" => :el_capitan
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /#{prefix}/, shell_output("#{bin}/onig-config --prefix")
  end
end
