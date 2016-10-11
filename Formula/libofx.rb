class Libofx < Formula
  desc "Library to support OFX command responses"
  homepage "http://libofx.sourceforge.net"
  url "https://downloads.sourceforge.net/project/libofx/libofx/0.9.10/libofx-0.9.10.tar.gz"
  sha256 "54e26a4944ef2785087cfd8ed8f187ab9d397d9b92b5acc199dd7d5d095cf695"

  bottle do
    sha256 "f43a3d30d5490038591245675c739613720c50502630cf21574e2de401b5ad8f" => :sierra
    sha256 "51e0d70b279d22394058c04cc4509788047d9d6cdb0ac7ed7a121f2863bddb7b" => :el_capitan
    sha256 "f569247d3c0849ed8ebe0d639fb281f64ce175c6db38241f1c60e5d46dc0cff6" => :yosemite
    sha256 "d2aedd050d47d0ca1274a34cf6ae14f3a2a4c8db65309ab3d46554c9d64ccd2b" => :mavericks
  end

  depends_on "open-sp"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "ofxdump #{version}", shell_output("ofxdump -V").chomp
  end
end
