class Cmatrix < Formula
  desc "Console Matrix"
  homepage "https://www.asty.org/cmatrix/"
  url "https://www.asty.org/cmatrix/dist/cmatrix-1.2a.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/c/cmatrix/cmatrix_1.2a.orig.tar.gz"
  sha256 "1fa6e6caea254b6fe70a492efddc1b40ad7ccb950a5adfd80df75b640577064c"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ef82e10a50d453e2c72dab3fe06dd932548606157bdf0ce5241ccb2dd8272cb1" => :catalina
    sha256 "f0234fbba18ba6a7d624192b3294ec52378c11a01e9e2ee58dd1cc062738dede" => :mojave
    sha256 "de744cafdaf5a208200e0a8fe13327d700396dae1162de3db6ffec67f4770808" => :high_sierra
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/cmatrix", "-V"
  end
end
