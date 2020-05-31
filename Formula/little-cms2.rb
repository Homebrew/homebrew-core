class LittleCms2 < Formula
  desc "Color management engine supporting ICC profiles"
  homepage "http://www.littlecms.com/"
  # Ensure release is announced on http://www.littlecms.com/download.html
  url "https://downloads.sourceforge.net/project/lcms/lcms/2.10/lcms2-2.10.tar.gz"
  sha256 "e11bc4e538587ec1530f9fef25f77261b94d5886c5ea81d8bb171a802df970ad"
  version_scheme 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "fc3b420e222a614a0f5b9fb91af41117ea1290ff19ea73dfc5e1b2021289b1b1" => :catalina
    sha256 "1c69f212b9754cbc1700e822ceb659103cb692afe2e26366c9ae9eb9e3fc612d" => :mojave
    sha256 "c232c3e514ef478c4fab797dab8db675045eae3611043063d338c256f4ecb941" => :high_sierra
    sha256 "a0ce195a712977870d9ddc414c0c5cd1b373d4e04b7130b80d00f911d04fe5b4" => :sierra
    sha256 "fa72bb1ce13889405ee93519be86ff1cede056d8c74e1d1671cca52013762ec0" => :el_capitan
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
