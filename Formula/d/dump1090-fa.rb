class Dump1090Fa < Formula
  desc "FlightAware ADS-B Ground Station System for SDRs"
  homepage "https://github.com/flightaware/dump1090"
  url "https://github.com/flightaware/dump1090/archive/refs/tags/v11.0.tar.gz"
  sha256 "e6fbee5ddf61ca80ccea69efaba277d135b8a1a4c7bb684616d3bd3b00655551"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "203dd48c495bdccd238cff69f969343cfa8cb4b03dc9600525f6f7104a5655fb"
    sha256 cellar: :any,                 arm64_sequoia: "e2f575133ad8f2e70eeb7c11acc0255740111524da4cdc525a3f4f559e85d64a"
    sha256 cellar: :any,                 arm64_sonoma:  "acf4a9f05127f9fbb12860035933b7b9759fa09043c9957936e478a0728b7a2b"
    sha256 cellar: :any,                 sonoma:        "3377684f779b02225b5043654d7e54843496b92982ba96251f63f6fe77108fb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7f640aa159d38303dcdd8e4895b910f694a81d6e208d36818f9a893c8416893d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14e270b099ff5d0f83c6e275fa9542030033d56cb2e4f72546b0ff0b31fc6d11"
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
