class Iperf3 < Formula
  desc "Update of iperf: measures TCP, UDP, and SCTP bandwidth"
  homepage "https://github.com/esnet/iperf"
  url "https://github.com/esnet/iperf/archive/3.10.1.tar.gz"
  sha256 "6a4bb4d5c124b3fa64dfbda469ab16857ad6565310bcaa3dd8cd32f96c2fc473"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "1372494b86b3d059cbd65e4f5b33db658d3f8a302a1e593f41c5139d56455f05"
    sha256 cellar: :any, big_sur:       "294200ffa7ed707d26f12b9a9ee12ad7604066e1d3868798f3794569c32526c6"
    sha256 cellar: :any, catalina:      "3e933685874b7b5a5c6de814e90ddb25afae5c267f9be2cfc16350a1e3469b19"
    sha256 cellar: :any, mojave:        "49dc7070ba1f1c2ce73795e88e6acb1bca113faf882d3d25cf91c940c4a9a42d"
  end

  head do
    url "https://github.com/esnet/iperf.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl@1.1"

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--disable-profiling",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}"
    system "make", "clean" # there are pre-compiled files in the tarball
    system "make", "install"
  end

  test do
    server = IO.popen("#{bin}/iperf3 --server")
    sleep 1
    assert_match "Bitrate", pipe_output("#{bin}/iperf3 --client 127.0.0.1 --time 1")
  ensure
    Process.kill("SIGINT", server.pid)
    Process.wait(server.pid)
  end
end
