class Biogeme < Formula
  desc "Maximum likelihood estimation of choice models"
  homepage "https://biogeme.epfl.ch/"
  url "https://biogeme.epfl.ch/distrib/biogeme-2.6a.tar.gz"
  sha256 "f6de0ea12f83ed183f31a41b9a56d1ec7226d2305549fb89ea7b1de8273ede49"
  revision 1

  bottle do
    sha256 "ad1acb781c111abdf62634521e86ffe85e7bec8c2738218ee50925e5502af40b" => :high_sierra
    sha256 "834ed929bffab2660b7a2fea398dfcea480b8f59ed2d5dac350e65269cf997f1" => :sierra
    sha256 "9f1ce4b715beb128766b714d52872c26e688c5b1960b17ce8ab480796946043e" => :el_capitan
  end

  depends_on "python3"
  depends_on "gtkmm3"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"minimal.py").write <<~EOS
      from biogeme import *
      rowIterator('obsIter')
      BIOGEME_OBJECT.SIMULATE = Enumerate({'Test':1},'obsIter')
    EOS
    (testpath/"minimal.dat").write <<~EOS
      TEST
      1
    EOS
    system bin/"pythonbiogeme", "minimal", "minimal.dat"
  end
end
