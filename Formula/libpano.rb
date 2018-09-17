class Libpano < Formula
  desc "Build panoramic images from a set of overlapping images"
  homepage "https://panotools.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/panotools/libpano13/libpano13-2.9.19/libpano13-2.9.19.tar.gz"
  version "13-2.9.19"
  sha256 "037357383978341dea8f572a5d2a0876c5ab0a83dffda431bd393357e91d95a8"
  revision 2

  bottle do
    cellar :any
    sha256 "0df8e9b94be82d01f9371286fa934b03ea957fc3d14fea8e2b71e5254c4077b4" => :mojave
    sha256 "2f41d44eeb64fce3d6451e4010a90a088f2db1c0bc1fb61d90f869f5eb6dd247" => :high_sierra
    sha256 "ee3a892768cab28490d0c5719d503faec655ed274b42d21cd93413c269430bfa" => :sierra
    sha256 "cde19367882bcb0f1ef6aa389a56fad271dbe956055b8c3e7cafe9c27a559478" => :el_capitan
    sha256 "d78f4a20ee2b3a55e91cb04f9655f719631fe8b3ac9ffed162e88a337a6e3a08" => :yosemite
  end

  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
