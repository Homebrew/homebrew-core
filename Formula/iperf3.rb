class Iperf3 < Formula
  desc "Update of iperf: measures TCP, UDP, and SCTP bandwidth"
  homepage "https://github.com/esnet/iperf"
  url "https://github.com/esnet/iperf/archive/3.7.tar.gz"
  sha256 "c349924a777e8f0a70612b765e26b8b94cc4a97cc21a80ed260f65e9823c8fc5"
  revision 1

  bottle do
    cellar :any
    sha256 "8ac59ee41772cc626b683fd52b5647bfcf947d3fc8f5bc3672b2e37a7b05d71e" => :mojave
    sha256 "3f5bd19f55d0635ce7ff229d404076513c374a30865b24b43b9094aae0453c25" => :high_sierra
    sha256 "f50d4b377603451b62e60b8cb25e0bcb2cc808ba02f3474af1e922d22ec2ddc3" => :sierra
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
