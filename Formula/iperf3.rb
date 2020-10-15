class Iperf3 < Formula
  desc "Update of iperf: measures TCP, UDP, and SCTP bandwidth"
  homepage "https://github.com/esnet/iperf"
  url "https://github.com/esnet/iperf/archive/3.9.tar.gz"
  sha256 "c6d8076b800f2b51f92dc941b0a9b77fbf2a867f623b5cb3cbf4754dabc40899"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "de2b4908fa73a967a17802a38447db1292e77842635eb905cda9fb776544e4fd" => :catalina
    sha256 "a17ff5710f6dd6cf26d85044be605580b4174e03f4b655f37b18279bf072f10c" => :mojave
    sha256 "ab41072fd6fb38994bbcedd1fa1cd1ad78feef49ecf56e45d0dcc96812cdf666" => :high_sierra
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
