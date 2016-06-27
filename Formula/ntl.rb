class Ntl < Formula
  desc "C++ number theory library"
  homepage "http://www.shoup.net/ntl"
  url "http://www.shoup.net/ntl/ntl-9.10.0.tar.gz"
  sha256 "5b4b8656e6a436944dbe26aa03d1b4b44cac669efd5b1cb88a7b328c89bb53c1"

  bottle do
    cellar :any_skip_relocation
    sha256 "17e1f03d95aaad97062bf78c1e1ff02912e017a0609afbea1fc770e7aaf6d3b3" => :el_capitan
    sha256 "c94a4696417e37df6e6dfae09adf01352b017a0ce01ab90aa80e5d7690441a07" => :yosemite
    sha256 "2d11cff1113e8d3539eb5f6bb72006cb136c5265e72a2a8b27fec699fcf4f208" => :mavericks
  end

  depends_on "gmp"

  def install
    args = ["PREFIX=#{prefix}"]

    cd "src" do
      system "./configure", *args
      system "make"
      system "make", "check"
      system "make", "install"
    end
  end
end
