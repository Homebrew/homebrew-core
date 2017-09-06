class Flowgrind < Formula
  desc "TCP measurement tool, similar to iperf or netperf"
  homepage "https://launchpad.net/flowgrind"
  url "https://launchpad.net/flowgrind/trunk/flowgrind-0.8.0/+download/flowgrind-0.8.0.tar.bz2"
  sha256 "2e8b58fc919bb1dae8f79535e21931336355b4831d8b5bf75cf43eacd1921d04"

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
