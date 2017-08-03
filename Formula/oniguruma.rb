class Oniguruma < Formula
  desc "Regular expressions library"
  homepage "https://github.com/kkos/oniguruma/"
  url "https://github.com/kkos/oniguruma/releases/download/v6.5.0/onig-6.5.0.tar.gz"
  sha256 "fc78898665dea1e2fbeda0609074ff76f5ef2001907f6184468c752eb52a3ed4"

  bottle do
    cellar :any
    sha256 "049210a103e7b6a30c86a4eabbed85625f95e032939ab9b92f941274e8d5c899" => :sierra
    sha256 "15325e173cce91a667e1253ad73ed0f0204d3e1e46602a2d3695ada49615921c" => :el_capitan
    sha256 "fedaf7e16254edd1676067413170265c4002e41614db826f9fda12a03bb22c78" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /#{prefix}/, shell_output("#{bin}/onig-config --prefix")
  end
end
