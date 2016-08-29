class Oniguruma < Formula
  desc "Regular expressions library"
  homepage "https://github.com/kkos/oniguruma/"
  url "https://github.com/kkos/oniguruma/releases/download/v6.1.0/onig-6.1.0.tar.gz"
  sha256 "cf465feb7aff17e784a0d848bdad68846d4bffbb131e8f87976dcb16bd232144"

  bottle do
    cellar :any
    sha256 "42df97346800435ea0ee496fd458c75e68888ee3f509a666bd91cd2a8069ac28" => :el_capitan
    sha256 "15b07bb276d288ec490dc8b5dcc2d6ced99954b28f53ceaacbd73f86f01eeabc" => :yosemite
    sha256 "78429a3c69ecbe6909e6e6e7eb3c169e0b36fc71621b3a15a9d191f809dd28b5" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /#{prefix}/, shell_output("#{bin}/onig-config --prefix")
  end
end
