class Icoutils < Formula
  desc "Create and extract MS Windows icons and cursors"
  homepage "https://www.nongnu.org/icoutils/"
  url "https://savannah.nongnu.org/download/icoutils/icoutils-0.32.2.tar.bz2"
  sha256 "e892affbdc19cb640b626b62608475073bbfa809dc0c9850f0713d22788711bd"

  bottle do
    cellar :any
    sha256 "ede0fe81bdef677d33a2ae3623e80af88f5b0de0808c585eb763d292c52565b1" => :high_sierra
    sha256 "086f7d8fa79c9e8315b34dd97e1662ec2111c8a7c78defb017fab0c73ba81918" => :sierra
    sha256 "dfa6965cb36ea05b8bd9073adc9026b7f25f14bd7905dd9e1f565697a7bc62a2" => :el_capitan
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
