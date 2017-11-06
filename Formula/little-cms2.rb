class LittleCms2 < Formula
  desc "Color management engine supporting ICC profiles"
  homepage "http://www.littlecms.com/"
  url "https://downloads.sourceforge.net/project/lcms/lcms/2.9/lcms2-2.9.tar.gz"
  sha256 "00756bed09ce059a68289f10de56b00267667647393ddc30400cb87c0d9037d5"

  bottle do
    cellar :any
    sha256 "727070ab0a397a51c21d6b8f5776dd6cd2e111a0dab38e6071a947e6e12267d0" => :high_sierra
    sha256 "5175bace6103d7ca8fb014db619bc11cb0d0fb29bcd2430d8e3dac3bda745a69" => :sierra
    sha256 "23b02130356986222e3f6c16aa85cadd674e2fca33ebe044adc95a16c12bb093" => :el_capitan
    sha256 "3cbcf21c725ccb1a260433b99136762cbbe8938a33ecdc8cdc82a48c7eb5acb7" => :yosemite
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
