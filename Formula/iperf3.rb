class Iperf3 < Formula
  desc "Update of iperf: measures TCP, UDP, and SCTP bandwidth"
  homepage "https://github.com/esnet/iperf"
  url "https://github.com/esnet/iperf/archive/3.10.tar.gz"
  sha256 "03cc873533ae6af54916f886a3e204c3bf1bd3e9de33759dc2718feade63fd4e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e03780161e2186e71eee0c94c9e7e1cf771bf29eba0b7ee0e403e5c5a001ec72"
    sha256 cellar: :any, big_sur:       "03bc9b67b96e6ce9aaa7a9b42a488821f2ac6aa886a4c705def1a4711040cbc9"
    sha256 cellar: :any, catalina:      "de2b4908fa73a967a17802a38447db1292e77842635eb905cda9fb776544e4fd"
    sha256 cellar: :any, mojave:        "a17ff5710f6dd6cf26d85044be605580b4174e03f4b655f37b18279bf072f10c"
    sha256 cellar: :any, high_sierra:   "ab41072fd6fb38994bbcedd1fa1cd1ad78feef49ecf56e45d0dcc96812cdf666"
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
