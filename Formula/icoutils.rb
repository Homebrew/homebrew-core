class Icoutils < Formula
  desc "Create and extract MS Windows icons and cursors"
  homepage "http://www.nongnu.org/icoutils/"
  url "https://savannah.nongnu.org/download/icoutils/icoutils-0.32.0.tar.bz2"
  sha256 "17234d6e922f5dcd2dc8351a4b3535a2f348bb9b92c17ca3e438132147019ca6"

  bottle do
    cellar :any
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
