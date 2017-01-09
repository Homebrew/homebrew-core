class Icoutils < Formula
  desc "Create and extract MS Windows icons and cursors"
  homepage "http://www.nongnu.org/icoutils/"
  url "https://savannah.nongnu.org/download/icoutils/icoutils-0.31.1.tar.bz2"
  sha256 "26e29d3c78f25d4cdf402501ac0414c51a9a092daebf6c9dee3b837dee693093"

  bottle do
    cellar :any
    sha256 "8105abde4120c99f387bb64ea1b2f9e85e88bf6c3338b2a0b44455fc023325a3" => :sierra
    sha256 "132017221967f98d1d7ec8f69bdbb0642c0df6fcb89d4f27f76c5573139a18ab" => :el_capitan
    sha256 "c4f42688697ab82d47526c1ff5479d0b912c191426ec74c3b0de934da93b29ae" => :yosemite
  end

  depends_on "libpng"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-rpath",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/icotool", "-l", test_fixtures("test.ico")
  end
end
