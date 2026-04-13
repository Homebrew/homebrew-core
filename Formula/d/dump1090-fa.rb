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

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1b1beb064155552de153c46e76829e48848e3d12ad29d146ddb0ff6470828bb9"
    sha256 cellar: :any,                 arm64_sequoia: "43396d0e29c5c5ddb8c315d863df7e6f0352eba555280319a05fb5623de70b13"
    sha256 cellar: :any,                 arm64_sonoma:  "27f55d9c38331b9b0bc9233bd34643b88395d3db4076d9625aad602a3bd4167a"
    sha256 cellar: :any,                 sonoma:        "143e0079e96f0022fc9e4d118e3140288fb96d44a9c560580356444b46859f98"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "657aacbfc8f08a7cf09dc96e0f0187e7bba4e48900c5e1257ca2659e38e3f1ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ba610d7e1fcb90a5ee3280ba6c1ca8f16915216bd398e60afcef481cbe7e0e6"
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
