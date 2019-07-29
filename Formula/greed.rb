class Greed < Formula
  desc "Game of consumption"
  homepage "http://www.catb.org/~esr/greed/"
  url "http://www.catb.org/~esr/greed/greed-4.2.tar.gz"
  sha256 "702bc0314ddedb2ba17d4b55d873384a1606886e8d69f35ce67f6e3024a8d3fd"
  head "https://gitlab.com/esr/greed.git"

  bottle do
    sha256 "7cbb6b4c078a0261607e24971831dad5e21b6616f5d8adffe0bcaa4cb98f3339" => :mojave
    sha256 "48e748cf4efb284edd099918a7d3015b4d01e50e868ac47ea2d0978cb3255773" => :high_sierra
    sha256 "9778c36a897958eac89c32b7c4ef3fa790a2800e22c03262442530e09474da77" => :sierra
    sha256 "99eef3acefdd2f116d3d3052f11efa9baf848aa4ba6452f07741a922d18779f5" => :el_capitan
    sha256 "2a503ee5dbbf11e7d7627e6535cc4691bd5606d981b0bfc416c20bfe9f393013" => :yosemite
  end

  def install
    # Handle hard-coded destination
    inreplace "Makefile", "/usr/share/man/man6", man6
    # Make doesn't make directories
    bin.mkpath
    man6.mkpath
    (var/"greed").mkpath
    # High scores will be stored in var/greed
    system "make", "SFILE=#{var}/greed/greed.hs"
    system "make", "install", "BIN=#{bin}"
  end

  def caveats; <<~EOS
    High scores will be stored in the following location:
      #{var}/greed/greed.hs
  EOS
  end

  test do
    assert_predicate bin/"greed", :executable?
  end
end
