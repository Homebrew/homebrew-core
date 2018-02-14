class Iperf3 < Formula
  desc "Update of iperf: measures TCP, UDP, and SCTP bandwidth"
  homepage "https://github.com/esnet/iperf"
  url "https://github.com/esnet/iperf/archive/3.4.tar.gz"
  sha256 "b3f21f4e5fa88a9fcce5955da5765ae888b7969582b81aa754ac098e33ef52ce"

  bottle do
    cellar :any
    sha256 "de271ddb90cbba7502bb5ddaa2c61efca3853dc3e161770e152f560851fc1d58" => :high_sierra
    sha256 "4d3de5c4be1a5bedeaabfadaed5f920a15812b2117b93d733cdd3c7397819867" => :sierra
    sha256 "fdefe297eeca30db994dc4dd084200998943cb1118a888a49c76c63a4670cd89" => :el_capitan
  end

  head do
    url "https://github.com/esnet/iperf.git"

    depends_on "libtool" => :build
    depends_on "automake" => :build
    depends_on "autoconf" => :build
  end

  depends_on "openssl"

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "make", "clean" # there are pre-compiled files in the tarball
    system "make", "install"
  end

  test do
    begin
      server = IO.popen("#{bin}/iperf3 --server")
      sleep 1
      assert_match "Bitrate", pipe_output("#{bin}/iperf3 --client 127.0.0.1 --time 1")
    ensure
      Process.kill("SIGINT", server.pid)
      Process.wait(server.pid)
    end
  end
end
