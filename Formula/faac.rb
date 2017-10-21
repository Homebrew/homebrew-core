class Faac < Formula
  desc "ISO AAC audio encoder"
  homepage "http://www.audiocoding.com/faac.html"
  url "https://downloads.sourceforge.net/project/faac/faac-src/faac-1.29/faac-1.29.8.2.tar.gz"
  sha256 "49f397b5604cf60fe5d453a34568a4fd403750445e3ff5b9ef82138f9b230747"

  bottle do
    cellar :any
    sha256 "5095668f558a03878ac785fceea965ba2d1b2cd42c94f2c0ed12f8e78db8a73b" => :high_sierra
    sha256 "3d608eaaa2ca08d191d7a6064dc7e7b97b0d599dc2bca3caac475caa9cbb20a2" => :sierra
    sha256 "bd669444cd56c2fb6a8cf014218df2fdd209ea8da39c12d4d4668e5a3425e8ac" => :el_capitan
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"faac", test_fixtures("test.mp3"), "-P", "-o", "test.m4a"
    assert_predicate testpath/"test.m4a", :exist?
  end
end
