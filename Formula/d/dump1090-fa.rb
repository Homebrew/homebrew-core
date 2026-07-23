class Dump1090Fa < Formula
  desc "FlightAware ADS-B Ground Station System for SDRs"
  homepage "https://github.com/flightaware/dump1090"
  url "https://github.com/flightaware/dump1090/archive/refs/tags/v11.1.tar.gz"
  sha256 "21fe1164d9b189274f6837bfffad7a1fe1b3471187ade4b5dc0409c1e640143f"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "573beeff957511395d526e3723a40b1e234c89ab146e19e6382905f56f7fa4ba"
    sha256 cellar: :any, arm64_sequoia: "d526e8f838272ec56798dd124ce3f0227f97eae5de2ef00f3cb9a8eede93e457"
    sha256 cellar: :any, arm64_sonoma:  "adce2671da170c9126f719b4488bb66671bf01a44f3c4ee56aca7595b88569cf"
    sha256 cellar: :any, sonoma:        "075fe86e6c28a56419749e58021055b1636adf1db636100ff1485cea391e4972"
    sha256 cellar: :any, arm64_linux:   "5396ce30eb393a6a61675d59fcac3495acc2625cbbfb77132f1677a11ad330bf"
    sha256 cellar: :any, x86_64_linux:  "b254ffb96130d68bf9b18855ed613ebff72278606442ac6a9397c5d85ffeb9e7"
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
