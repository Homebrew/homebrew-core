class Pilotprotocol < Formula
  desc "Network stack for AI agents - addresses, ports, tunnels, encryption, trust"
  homepage "https://pilotprotocol.network"
  url "https://github.com/TeoSlayer/pilotprotocol/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "a1db989d68b04e5e84d8c32548ab4f0cd7f353bc8b2dbde05f5d75d2d5a9ae75"
  license "AGPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"pilot-daemon"), "./cmd/daemon"
    system "go", "build", *std_go_args(ldflags:, output: bin/"pilotctl"), "./cmd/pilotctl"
    system "go", "build", *std_go_args(ldflags:, output: bin/"pilot-gateway"), "./cmd/gateway"
    system "go", "build", *std_go_args(ldflags:, output: bin/"pilot-updater"), "./cmd/updater"
  end

  def post_install
    (var/"pilot").mkpath
  end

  def caveats
    <<~EOS
      To get started:
        pilotctl daemon start --hostname my-agent --email you@example.com
        pilotctl info

      Documentation: https://pilotprotocol.network/docs
    EOS
  end

  service do
    run [
      opt_bin/"pilot-daemon",
      "-registry", "34.71.57.205:9000",
      "-beacon", "34.71.57.205:9001",
      "-socket", "/tmp/pilot.sock",
      "-encrypt"
    ]
    keep_alive crashed: true
    log_path var/"log/pilot-daemon.log"
    error_log_path var/"log/pilot-daemon.log"
  end

  test do
    assert_match "pilotctl", shell_output("#{bin}/pilotctl -h 2>&1")
    assert_match version.to_s, shell_output("#{bin}/pilotctl version 2>&1")
  end
end
