class Dump1090Fa < Formula
  desc "FlightAware ADS-B Ground Station System for SDRs"
  homepage "https://github.com/flightaware/dump1090"
  url "https://github.com/flightaware/dump1090/archive/refs/tags/v10.2.tar.gz"
  sha256 "1135588ea8f3d045601e8ab45702648e339168eee0792b2c4f62fae3d2cc9f3b"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "pkgconf" => :build
  depends_on "libbladerf"
  depends_on "librtlsdr"
  depends_on "ncurses"

  def install
    system "make", "DUMP1090_VERSION=#{version}"
    bin.install "dump1090"
    bin.install "view1090"
  end

  test do
    output_log = testpath/"output.log"
    port = free_port
    pid = spawn bin/"dump1090", "--device-type", "none", "--net-ri-port", port.to_s, [:out, :err] => output_log.to_s
    begin
      sleep 5
      TCPSocket.open("localhost", port) { |sock| sock.puts "*8D3C5EE69901BD9540078D37335F;" }
      sleep 5
      assert_match "Groundspeed:   475.1 kt", output_log.read
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
