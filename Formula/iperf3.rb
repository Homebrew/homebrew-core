class Iperf3 < Formula
  desc "Update of iperf: measures TCP, UDP, and SCTP bandwidth"
  homepage "https://github.com/esnet/iperf"
  url "https://github.com/esnet/iperf/archive/3.7.tar.gz"
  sha256 "c349924a777e8f0a70612b765e26b8b94cc4a97cc21a80ed260f65e9823c8fc5"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "b1d4d9506ebfb8ae48882cf4f810b6d52fbbd388211f372e5d56f08abaf61ad3" => :catalina
    sha256 "32763a4631055100f4c0e5787aedf3f5c73ebc8a9d238b3b08ba66f052a035a3" => :mojave
    sha256 "657bce37d98fbe976445e58f0ef70cd637c5a5223a1a580af3ab33508d07e8a7" => :high_sierra
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
