class Flowgrind < Formula
  desc "TCP measurement tool, similar to iperf or netperf"
  homepage "https://launchpad.net/flowgrind"
  url "https://launchpad.net/flowgrind/trunk/flowgrind-0.7.5/+download/flowgrind-0.7.5.tar.bz2"
  sha256 "7d7fec5e62d34422a7cadeab4a5d65eb3ffb600e8e6861fd3cbf16c29b550ae4"
  revision 2

  bottle do
    cellar :any
    sha256 "57550eebc62d8a105cc82856571e4d31f6b9fcca83390ec5b24ae29bb6fa9d1b" => :sierra
    sha256 "aeaf5c5a359cd07f13a9ef8c38ee75ff7bff94a86e751bf990f9741943ee8066" => :el_capitan
    sha256 "a11e7064945a39adafcc5ba607ac2522bc928b130bcf92e575e65b5feca82a80" => :yosemite
    sha256 "8fec1cceaea769c8f98bcbd423bab0bb69003288ba1f0932c7d6de1b64845789" => :mavericks
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
