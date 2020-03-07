class Libowfat < Formula
  desc "Reimplements libdjb"
  homepage "https://www.fefe.de/libowfat/"
  url "https://www.fefe.de/libowfat/libowfat-0.32.tar.xz"
  sha256 "f4b9b3d9922dc25bc93adedf9e9ff8ddbebaf623f14c8e7a5f2301bfef7998c1"
  head ":pserver:cvs:@cvs.fefe.de:/cvs", :using => :cvs

  bottle do
    cellar :any_skip_relocation
    sha256 "3f20940695f42a2c551a9e93d34e330ddf94906b43ad589cc0de037d4dd0de3f" => :catalina
    sha256 "86a90bda438ddf8d328a4377ae661911e830b42e4cfdd699d6712845e7dc75b1" => :mojave
    sha256 "43e3968245f33399038ffb25f48618be370cb8242f38ddc36170b76cfd0da3fe" => :high_sierra
    sha256 "4f719fe2a03651ecea7882464e5b8fd1f4f3b1e32a0f75f9e5cd9e66ad32a123" => :sierra
    sha256 "be87e0da446834d6f8f808c434e854ff7c9eb88c3f899fc48a830b36117cac83" => :el_capitan
  end

  patch do
    url "https://github.com/mistydemeo/libowfat/commit/278a675a6984e5c202eee9f7e36cda2ae5da658d.patch?full_index=1"
    sha256 "32eab2348f495f483f7cd34ffd7543bd619f312b7094a4b55be9436af89dd341"
  end

  def install
    system "make", "libowfat.a"
    system "make", "install", "prefix=#{prefix}", "MAN3DIR=#{man3}", "INCLUDEDIR=#{include}/libowfat"
  end
end
