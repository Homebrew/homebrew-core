class Biogeme < Formula
  desc "Maximum likelihood estimation of choice models"
  homepage "https://biogeme.epfl.ch/"
  url "https://biogeme.epfl.ch/distrib/biogeme-2.6a.tar.gz"
  sha256 "f6de0ea12f83ed183f31a41b9a56d1ec7226d2305549fb89ea7b1de8273ede49"
  revision 5

  bottle do
    cellar :any
    sha256 "669b97da46ec4e508169b764b6c801682f9282702ec6f17d32f9e4b7426cf8dc" => :mojave
    sha256 "b90e3f0d203a5ad33d2ad1f70e12503a93784bb4a97d78b284c0d4c746666ea5" => :high_sierra
    sha256 "cad38740685b800f07bece9dd13238b900427155697582fc689bd3eee42e8c38" => :sierra
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
