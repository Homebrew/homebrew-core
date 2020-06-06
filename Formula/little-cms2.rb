class LittleCms2 < Formula
  desc "Color management engine supporting ICC profiles"
  homepage "http://www.littlecms.com/"
  # Ensure release is announced on http://www.littlecms.com/download.html
  url "https://downloads.sourceforge.net/project/lcms/lcms/2.10/lcms2-2.10.tar.gz"
  sha256 "50d411fd494c7c6973866e08c05dea83245d7e23a0db6237a9d00f88b2e0f346"
  revision 1
  version_scheme 1

  bottle do
    cellar :any
    sha256 "73e92367d80b786140172f2fedc96e8dc935fbd5daa53b796e1572707ba7788d" => :catalina
    sha256 "1d92fdb6dfbacebb2431da4c3c9e2c8d791fa6db7705a90b6cc1547b3b55747a" => :mojave
    sha256 "5018fd6feb5608d7f773c4de548cef619b6d0a306d317c2f81129885af523311" => :high_sierra
  end

  depends_on "jpeg"
  depends_on "libtiff"

  def install
    args = %W[--disable-dependency-tracking --prefix=#{prefix}]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/jpgicc", test_fixtures("test.jpg"), "out.jpg"
    assert_predicate testpath/"out.jpg", :exist?
  end
end
