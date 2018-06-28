class Biogeme < Formula
  desc "Maximum likelihood estimation of choice models"
  homepage "https://biogeme.epfl.ch/"
  url "https://biogeme.epfl.ch/distrib/biogeme-2.6a.tar.gz"
  sha256 "f6de0ea12f83ed183f31a41b9a56d1ec7226d2305549fb89ea7b1de8273ede49"
  revision 4

  bottle do
    sha256 "0de544ac15c321308098429f277db189a94e724cb2d18595fb982826de542432" => :high_sierra
    sha256 "f2d4a89247012c1870d9b042523075c0762c3f3bfe904dcd98bffbb53b44c49a" => :sierra
    sha256 "db6dcc0c3c0433de7189d570b871e7d63c484da4a8c4733caac025ccbc2ef179" => :el_capitan
  end

  depends_on "python"
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
