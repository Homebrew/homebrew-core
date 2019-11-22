class Ndpi < Formula
  desc "Deep Packet Inspection (DPI) library"
  homepage "https://www.ntop.org/products/deep-packet-inspection/ndpi/"
  url "https://github.com/ntop/nDPI/archive/2.8.tar.gz"
  sha256 "f98def4d0e43818317b20e2887ce500b2d6a5a9c8ddb28cf57ae51caae0f33cc"
  head "https://github.com/ntop/nDPI.git", :branch => "dev"

  bottle do
    cellar :any
    sha256 "cf2ff87a20aa68e4ebc4777c121c963d9b0edb4bcdb3192ef915fd769795f713" => :catalina
    sha256 "dc154d9707bbf0243c811e455307778a237fa04f970c677021ddce99a6dc75ed" => :mojave
    sha256 "ab792cab341a8ba89aae05273d6082d79e758901362ae256e04a3aa9900a4174" => :high_sierra
    sha256 "1cccc0b5ae55ff767aeea7553c5a8ae063b92535ec1f06e575d8b8637b0cbf97" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "json-c"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"ndpiReader", "-i", test_fixtures("test.pcap")
  end
end
