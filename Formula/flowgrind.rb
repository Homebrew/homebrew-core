class Flowgrind < Formula
  desc "TCP measurement tool, similar to iperf or netperf"
  homepage "https://launchpad.net/flowgrind"
  url "https://launchpad.net/flowgrind/trunk/flowgrind-0.8.0/+download/flowgrind-0.8.0.tar.bz2"
  sha256 "2e8b58fc919bb1dae8f79535e21931336355b4831d8b5bf75cf43eacd1921d04"

  bottle do
    cellar :any
    sha256 "10f9b511118c62e1302d427a91b0972d61638a43b64594ba04731b7fa50fce77" => :sierra
    sha256 "112a89ea6071526c1604047b40cf5f168cc1ca3d779fa2c4b4093c8ee3675c39" => :el_capitan
    sha256 "a39cc57cb6353dfeae30da6c204c35956f6ef1570c3caf0419fa6c6e75ff0998" => :yosemite
  end

  depends_on "gsl"
  depends_on "xmlrpc-c"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/flowgrind", "--version"
  end
end
