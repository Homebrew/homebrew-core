class Flowgrind < Formula
  desc "TCP measurement tool, similar to iperf or netperf"
  homepage "https://launchpad.net/flowgrind"
  url "https://launchpad.net/flowgrind/trunk/flowgrind-0.7.5/+download/flowgrind-0.7.5.tar.bz2"
  sha256 "7d7fec5e62d34422a7cadeab4a5d65eb3ffb600e8e6861fd3cbf16c29b550ae4"
  revision 3

  bottle do
    cellar :any
    sha256 "b13583ff611b4c252d47e140555d2a05dfe619174ff77e63f4de7ab288c1e8d8" => :sierra
    sha256 "a53dc12f90921d61c7e62d9566630fc364ba13b818cd548dc87441c68cc53bb7" => :el_capitan
    sha256 "3b86d221274174dee723d0f8a1f49533b52e811d8a6646220e65c19973fbeb59" => :yosemite
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
