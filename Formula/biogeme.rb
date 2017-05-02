class Biogeme < Formula
  desc "Maximum likelihood estimation of choice models"
  homepage "http://biogeme.epfl.ch"
  url "http://biogeme.epfl.ch/distrib/biogeme-2.5.tar.gz"
  sha256 "88548e99f4f83c24bf7ddb8e0de07588adc2bec515569c56e816ed5b20a624b3"

  bottle do
    sha256 "57b8dc37a3f62f8158019ba7ed16955d84603e9d5544bf8ec43ca1b7f2c8ff5b" => :sierra
    sha256 "747a09308ea2475fc2d1e4823a352c1f5c10fadab1d88bf7250cd78c59a326ee" => :el_capitan
    sha256 "2f15fe2bc8ccf24889fdb13eba6f8e9299e55a277fa06417dc556802bb40e385" => :yosemite
  end

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
