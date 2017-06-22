class Biogeme < Formula
  desc "Maximum likelihood estimation of choice models"
  homepage "http://biogeme.epfl.ch"
  url "http://biogeme.epfl.ch/distrib/biogeme-2.6a.tar.gz"
  sha256 "f6de0ea12f83ed183f31a41b9a56d1ec7226d2305549fb89ea7b1de8273ede49"

  bottle do
    sha256 "eed003531786bc7e459b29b328ccf65b374a2e9aa23e190b694d2c13b8e44c43" => :sierra
    sha256 "9aa0816147a77c99af05717c7360b1a738f6b51d532a6e0908960ac49dc7940b" => :el_capitan
    sha256 "b6822b9c753fa818d79ba18857820e0a4c77944f47fd56b9dfcde444c73af6fe" => :yosemite
  end

  depends_on :python3
  depends_on "gtkmm3"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"minimal.py").write <<-EOS.undent
      from biogeme import *
      rowIterator('obsIter')
      BIOGEME_OBJECT.SIMULATE = Enumerate({'Test':1},'obsIter')
    EOS
    (testpath/"minimal.dat").write <<-EOS.undent
      TEST
      1
    EOS
    system bin/"pythonbiogeme", "minimal", "minimal.dat"
  end
end
