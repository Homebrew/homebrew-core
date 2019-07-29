class Libowfat < Formula
  desc "Reimplements libdjb"
  homepage "https://www.fefe.de/libowfat/"
  url "https://www.fefe.de/libowfat/libowfat-0.31.tar.xz"
  sha256 "d1e4ac1cfccbb7dc51d77d96398e6302d229ba7538158826c84cb4254c7e8a12"
  head ":pserver:cvs:@cvs.fefe.de:/cvs", :using => :cvs

  bottle do
    cellar :any_skip_relocation
    sha256 "86a90bda438ddf8d328a4377ae661911e830b42e4cfdd699d6712845e7dc75b1" => :mojave
    sha256 "43e3968245f33399038ffb25f48618be370cb8242f38ddc36170b76cfd0da3fe" => :high_sierra
    sha256 "4f719fe2a03651ecea7882464e5b8fd1f4f3b1e32a0f75f9e5cd9e66ad32a123" => :sierra
    sha256 "be87e0da446834d6f8f808c434e854ff7c9eb88c3f899fc48a830b36117cac83" => :el_capitan
  end

  def install
    system "make", "libowfat.a"
    system "make", "install", "prefix=#{prefix}", "MAN3DIR=#{man3}", "INCLUDEDIR=#{include}/libowfat"
  end
end
