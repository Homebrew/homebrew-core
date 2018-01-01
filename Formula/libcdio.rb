class Libcdio < Formula
  desc "Compact Disc Input and Control Library"
  homepage "https://www.gnu.org/software/libcdio/"
  url "https://ftp.gnu.org/gnu/libcdio/libcdio-2.0.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/libcdio/libcdio-2.0.0.tar.gz"
  sha256 "1b481b5da009bea31db875805665974e2fc568e2b2afa516f4036733657cf958"

  bottle do
    cellar :any
    sha256 "0d55434bb20a118b144413e1d20c36433c12f8e3243994cf011f15d6648a7157" => :high_sierra
    sha256 "d3cef83b0df1de2d41f1b52a0aaf3ac13a7c5e9629a327fd4cf1210fffa99466" => :sierra
    sha256 "a950c4704df57215a64a64bb0168f74afd75826998917cfb2cf77988cf9e1208" => :el_capitan
  end

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-dependency-tracking", "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/cd-info -v", 1)
  end
end
