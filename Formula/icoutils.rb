class Icoutils < Formula
  desc "Create and extract MS Windows icons and cursors"
  homepage "http://www.nongnu.org/icoutils/"
  url "https://savannah.nongnu.org/download/icoutils/icoutils-0.32.0.tar.bz2"
  sha256 "17234d6e922f5dcd2dc8351a4b3535a2f348bb9b92c17ca3e438132147019ca6"

  bottle do
    cellar :any
    sha256 "1d627f415154d1701ca684f688f9d2b3f06e98844626615620e6076df9f4a49c" => :sierra
    sha256 "ac584e12bc7623e171c074014d496143c1bdfbe5df6d71ab016fedf2f70fd274" => :el_capitan
    sha256 "b20b2064a797c0c522efa466fd4b77baee10188aa3f263f62f2fec20e8c0653b" => :yosemite
  end

  depends_on "libpng"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-rpath",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"icotool", "-l", test_fixtures("test.ico")
  end
end
