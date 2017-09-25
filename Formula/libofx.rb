class Libofx < Formula
  desc "Library to support OFX command responses"
  homepage "https://libofx.sourceforge.io"
  url "https://downloads.sourceforge.net/project/libofx/libofx/libofx-0.9.12.tar.gz"
  sha256 "c15fa062fa11e759eb6d8c7842191db2185ee1b221a3f75e9650e2849d7b7373"

  bottle do
    sha256 "81b676fdb2d88fb270bc189af82631dcdf4387ab296472ceea518b48bd307d1b" => :high_sierra
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
    assert_equal "ofxdump #{version}", shell_output("#{bin}/ofxdump -V").chomp
  end
end
