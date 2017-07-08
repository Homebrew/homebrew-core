class Iperf < Formula
  desc "Tool to measure maximum TCP and UDP bandwidth"
  homepage "https://github.com/esnet/iperf"
  url "https://github.com/esnet/iperf/archive/3.2.tar.gz"
  sha256 "cb20d3a33e07a3b45a49a358b044f4998f452ef9d1a8a5cbde476b6ab9e9b526"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "441219fd5a227aa8df41c61067d9ae20bb268c48bbdcdad5bce8deb5f32a45fe" => :sierra
    sha256 "4fabcfbc462ea67189847e6faba598a5952bd155e292696cfd39f4d709f926a2" => :el_capitan
    sha256 "37e46ed0ee35a3f0957d847ce4afc871c352108279f8c001c7879282a8706495" => :yosemite
    sha256 "67d2c2cef38fc34704f379a0dcf7d32d0b1bd5d30cd44f0533a6bd55f275bb8a" => :mavericks
  end

  depends_on "openssl"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
           "--prefix=#{prefix}",
           "--with-openssl=#{Formula["openssl"].opt_prefix}"
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
