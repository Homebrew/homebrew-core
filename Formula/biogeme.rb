class Biogeme < Formula
  desc "Maximum likelihood estimation of choice models"
  homepage "http://biogeme.epfl.ch"
  url "http://biogeme.epfl.ch/distrib/biogeme-2.5.tar.gz"
  sha256 "88548e99f4f83c24bf7ddb8e0de07588adc2bec515569c56e816ed5b20a624b3"

  depends_on :python3
  depends_on "gtkmm3"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-python",
                          "--enable-bison",
                          "--enable-gui"
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
