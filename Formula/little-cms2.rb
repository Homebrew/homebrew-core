class LittleCms2 < Formula
  desc "Color management engine supporting ICC profiles"
  homepage "http://www.littlecms.com/"
  # Ensure release is announced on http://www.littlecms.com/download.html
  url "https://downloads.sourceforge.net/project/lcms/lcms/2.8/lcms2-2.8.tar.gz"
  sha256 "66d02b229d2ea9474e62c2b6cd6720fde946155cd1d0d2bffdab829790a0fb22"
  revision 2
  version_scheme 1

  bottle do
    cellar :any
    sha256 "dd5a35dde6f45c11960ade379eafa77279dc03cc9e031c426294f987096c34ef" => :high_sierra
    sha256 "07b2dc8194334d2f57298c9121de1a2a923f171aa13226f1bee21c64e99b8ba0" => :sierra
    sha256 "0f9d803c751712b1d5ce5020d7a0a4cff758e72dbf0c1476ec9cb23cd29738bc" => :el_capitan
  end

  depends_on "jpeg" => :recommended
  depends_on "libtiff" => :recommended

  def install
    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    args << "--without-tiff" if build.without? "libtiff"
    args << "--without-jpeg" if build.without? "jpeg"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/jpgicc", test_fixtures("test.jpg"), "out.jpg"
    assert_predicate testpath/"out.jpg", :exist?
  end
end
