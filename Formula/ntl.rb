class Ntl < Formula
  desc "C++ number theory library"
  homepage "http://www.shoup.net/ntl"
  url "http://www.shoup.net/ntl/ntl-9.10.0.tar.gz"
  sha256 "5b4b8656e6a436944dbe26aa03d1b4b44cac669efd5b1cb88a7b328c89bb53c1"

  bottle do
    cellar :any_skip_relocation
    sha256 "ceb0a000d24c4a42b2d13bda306a433d36507230e0e97ce76ccc2a98043d579e" => :el_capitan
    sha256 "ae6675a32f40d891e9b9359373c136938ebbb0a40e26936793b5be907fde1b0b" => :yosemite
    sha256 "67d19b48bdc4591c39c89cb6e0431b4a1272735acf34354d54c86b4d244c70d3" => :mavericks
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
