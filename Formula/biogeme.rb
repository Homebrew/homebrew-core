class Biogeme < Formula
  desc "Maximum likelihood estimation of choice models"
  homepage "https://biogeme.epfl.ch/"
  url "https://biogeme.epfl.ch/distrib/biogeme-2.6a.tar.gz"
  sha256 "f6de0ea12f83ed183f31a41b9a56d1ec7226d2305549fb89ea7b1de8273ede49"
  revision 4

  bottle do
    cellar :any
    sha256 "058c5338d43d7a1b8a174583c6ab6dfe91fff41f476a6bd1a7561ec7758416db" => :mojave
    sha256 "9e0f2c7228e239a0476147fb818ba1bb635443ee6f4d776fe7879dfa2faa5936" => :high_sierra
    sha256 "aa71ee8900b00619fe1ac171c0196b3a4f56c4e1c1d7cecfd2230b7e289bf141" => :sierra
    sha256 "cceacdb78b3866310b0dbe2cf59148ab9b0d2c398f2f5f13bea6a218ef69cc46" => :el_capitan
  end

  depends_on "gtkmm3"
  depends_on "python"

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
