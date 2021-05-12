class Libpano < Formula
  desc "Build panoramic images from a set of overlapping images"
  homepage "https://panotools.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/panotools/libpano13/libpano13-2.9.20/libpano13-2.9.20.tar.gz"
  version "13-2.9.20"
  sha256 "3b532836c37b8cd75cd2227fd9207f7aca3fdcbbd1cce3b9749f056a10229b89"

  livecheck do
    url :stable
    regex(%r{url=.*?/libpano(\d+-\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, catalina:    "446728639c2cdf06291df1ecd510da3dcb0550163d73560eec6d13b0e3b28351"
    sha256 cellar: :any, mojave:      "0df8e9b94be82d01f9371286fa934b03ea957fc3d14fea8e2b71e5254c4077b4"
    sha256 cellar: :any, high_sierra: "2f41d44eeb64fce3d6451e4010a90a088f2db1c0bc1fb61d90f869f5eb6dd247"
    sha256 cellar: :any, sierra:      "ee3a892768cab28490d0c5719d503faec655ed274b42d21cd93413c269430bfa"
    sha256 cellar: :any, el_capitan:  "cde19367882bcb0f1ef6aa389a56fad271dbe956055b8c3e7cafe9c27a559478"
    sha256 cellar: :any, yosemite:    "d78f4a20ee2b3a55e91cb04f9655f719631fe8b3ac9ffed162e88a337a6e3a08"
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
