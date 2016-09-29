class ArgusClients < Formula
  desc "Audit Record Generation and Utilization System clients"
  homepage "http://qosient.com/argus/"
  url "http://qosient.com/argus/src/argus-clients-3.0.8.2.tar.gz"
  sha256 "32073a60ddd56ea8407a4d1b134448ff4bcdba0ee7399160c2f801a0aa913bb1"
  revision 1

  bottle do
    cellar :any
    sha256 "982c7d32e91f1fd551d87db458c7cd9770e46a4637b840dc1e82324c21b30087" => :sierra
    sha256 "cdc0e038a7f7d01e8d37d2e6c432f8d589104c8c9c73d06174a8c1ae63013865" => :el_capitan
    sha256 "7d0c81e5c0378b3faefbf893053be9492e6977e18393e0fe89d8b9e0e951d3b6" => :yosemite
  end

  depends_on "readline" => :recommended
  depends_on "rrdtool" => :recommended

  def install
    ENV.append "CFLAGS", "-std=gnu89"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
