class LittleCms2 < Formula
  desc "Color management engine supporting ICC profiles"
  homepage "http://www.littlecms.com/"
  # Ensure release is announced on http://www.littlecms.com/download.html
  url "https://downloads.sourceforge.net/project/lcms/lcms/2.9/lcms2-2.9.tar.gz"
  sha256 "48c6fdf98396fa245ed86e622028caf49b96fa22f3e5734f853f806fbc8e7d20"
  version_scheme 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "c232c3e514ef478c4fab797dab8db675045eae3611043063d338c256f4ecb941" => :high_sierra
    sha256 "a0ce195a712977870d9ddc414c0c5cd1b373d4e04b7130b80d00f911d04fe5b4" => :sierra
    sha256 "fa72bb1ce13889405ee93519be86ff1cede056d8c74e1d1671cca52013762ec0" => :el_capitan
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
