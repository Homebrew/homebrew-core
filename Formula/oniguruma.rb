class Oniguruma < Formula
  desc "Regular expressions library"
  homepage "https://github.com/kkos/oniguruma/"
  url "https://github.com/kkos/oniguruma/releases/download/v6.8.2/onig-6.8.2.tar.gz"
  sha256 "adeada5f6b54c2a6f58ff021831a01b18a62b55ea9935e972e36ebb19e7c4903"

  bottle do
    cellar :any
    sha256 "1162b530e6d568236539c165abb1a3aaad305a3a090d8884576e38aff8572956" => :mojave
    sha256 "f56c5eadeeef8a6276d60fc76381b41d33a7b0b2a4036a506edacb4be87a1dad" => :high_sierra
    sha256 "194728105a10c8dea861a77455b9c60f35b3950f75a870cb1d598e31587ec87e" => :sierra
    sha256 "ae49cb52498081b003b04c3b7aace56d51eb3f8cd3490362cc75f4a4091a9e5b" => :el_capitan
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /#{prefix}/, shell_output("#{bin}/onig-config --prefix")
  end
end
