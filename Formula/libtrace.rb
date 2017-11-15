class Libtrace < Formula
  desc "Library for trace processing supporting multiple inputs"
  homepage "https://research.wand.net.nz/software/libtrace.php"
  url "https://research.wand.net.nz/software/libtrace/libtrace-4.0.2.tar.bz2"
  sha256 "ff3960bd45cb3d123d58b134e9dffcd529dca49f0fb4e3b278426c51ff51f32c"

  bottle do
    sha256 "55fef057f55e4e3100f6b7f4a1a71d1a957604c168255fbda5b328939d34a8f0" => :high_sierra
    sha256 "e71eb55397b13f2a4f16d5625b0faf349781cea0200298d878f7ad8c959f9e2f" => :sierra
    sha256 "1140ea098064660ae866b8c9d8a80d5445a9c094ef7e1da79d6d20bea70e0dba" => :el_capitan
  end

  depends_on "openssl"
  depends_on "wandio"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
