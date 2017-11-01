class Icoutils < Formula
  desc "Create and extract MS Windows icons and cursors"
  homepage "http://www.nongnu.org/icoutils/"
  url "https://savannah.nongnu.org/download/icoutils/icoutils-0.32.2.tar.bz2"
  sha256 "e892affbdc19cb640b626b62608475073bbfa809dc0c9850f0713d22788711bd"

  bottle do
    cellar :any
    sha256 "556da22536c6be8a8e3b5602d47e5ef47dcbcec5394b9ff4b7517dea19f4cb6c" => :high_sierra
    sha256 "e610d5929aebf62ea55523c0b78086421ee1d986629f5e3d17da3db256dccff1" => :sierra
    sha256 "1c90d46e62314b26aa041cac0c1fc8ac118a8cb99ccfd13c0480490409c19f12" => :el_capitan
    sha256 "99093a0aa622a30d769ed6ac558e35e7621658c4210266f56a00bf9a4b36efb4" => :yosemite
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
