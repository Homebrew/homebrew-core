class Iperf3 < Formula
  desc "Update of iperf: measures TCP, UDP, and SCTP bandwidth"
  homepage "https://github.com/esnet/iperf"
  url "https://github.com/esnet/iperf/archive/3.5.tar.gz"
  sha256 "4c318707a29d46d7b64e517a4fe5e5e75e698aef030c6906e9b26dc51d9b1fce"

  bottle do
    cellar :any
    sha256 "0833a5d9771ff1365140ee204a9c0ad768cd2676bc29b7642941083302617c91" => :high_sierra
    sha256 "beef7813eb423f34ffb9915c758555197273e3ad0d4553cb168716122e81941c" => :sierra
    sha256 "f151cefe7c21e1a546438afc8d6b10c251da7a1b19f4767ece854df8125294d3" => :el_capitan
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
