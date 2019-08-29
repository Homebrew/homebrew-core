class Iperf3 < Formula
  desc "Update of iperf: measures TCP, UDP, and SCTP bandwidth"
  homepage "https://github.com/esnet/iperf"
  url "https://github.com/esnet/iperf/archive/3.7.tar.gz"
  sha256 "c349924a777e8f0a70612b765e26b8b94cc4a97cc21a80ed260f65e9823c8fc5"
  revision 1

  bottle do
    cellar :any
    sha256 "c6f1a298b199949fc2642cd6eb5860a5d9be4433d1cfbe88ec6734a97fdbfaf6" => :mojave
    sha256 "86cfc8e385961af48f2432773e5a5574d0aae07b7db14904b98c1f9c8d4f5063" => :high_sierra
    sha256 "c0e071e3241558fe1e96ee08a90d65af8429f5aa077454b4956a1183228a8271" => :sierra
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
