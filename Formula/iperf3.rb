class Iperf3 < Formula
  desc "Update of iperf: measures TCP, UDP, and SCTP bandwidth"
  homepage "https://github.com/esnet/iperf"
  url "https://github.com/esnet/iperf/archive/3.4.tar.gz"
  sha256 "b3f21f4e5fa88a9fcce5955da5765ae888b7969582b81aa754ac098e33ef52ce"

  bottle do
    cellar :any
    sha256 "4a360d9aa6f9b83b000f3d58bfdf15b144d3baeb17851c64cd6db90fbb93d53c" => :high_sierra
    sha256 "eb4e5addaa2338432eb3559ef7579c992bb344de9979cccf9c8c7cd21e39d32e" => :sierra
    sha256 "5caca9b1b6d4debb8034c772b5cf175980ec875599fc5e3a3076949000de92d8" => :el_capitan
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
