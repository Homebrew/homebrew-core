class Biogeme < Formula
  desc "Maximum likelihood estimation of choice models"
  homepage "https://biogeme.epfl.ch/"
  url "https://biogeme.epfl.ch/distrib/biogeme-2.6a.tar.gz"
  sha256 "f6de0ea12f83ed183f31a41b9a56d1ec7226d2305549fb89ea7b1de8273ede49"
  revision 2

  bottle do
    sha256 "ddd85600d73ba87a1eae36d926527d65f74c274a8e2e9df288d802a9a0cfc019" => :high_sierra
    sha256 "3eabad085275669c1b74b179de5c747d1a9c8799d06cce2895e4639150da29c0" => :sierra
    sha256 "e39844a42e4f9df896f6c416b085c1d2ce2edd6d05a24e8ac5c6d1dbc6c8bfd9" => :el_capitan
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
