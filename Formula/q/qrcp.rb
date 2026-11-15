class Qrcp < Formula
  desc "Transfer files to and from your computer by scanning a QR code"
  homepage "https://qrcp.sh"
  url "https://github.com/claudiodangelis/qrcp/archive/refs/tags/v0.11.7.tar.gz"
  sha256 "e3dcc23b85e2f37f378cf95b41a7a7c2ee5cd9941e3935a3325e3a0c8c770a06"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4c0030d2091a35b171841b25fa852571ede6f65b301602af5ef387ece2026083"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4c0030d2091a35b171841b25fa852571ede6f65b301602af5ef387ece2026083"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4c0030d2091a35b171841b25fa852571ede6f65b301602af5ef387ece2026083"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f3b8e031e4980377a1a55f881184dbe18dffeccb0f8bcc450fdadb1ae7bbc13e"
    sha256 cellar: :any,                 x86_64_linux:      "3727188f3322ee679221137f83b63657f6b278538d2642809006a032a91b9507"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/claudiodangelis/qrcp/version.version=#{version}
      -X github.com/claudiodangelis/qrcp/version.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"qrcp", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qrcp version")

    data = "Hello there, big world\n"
    port = free_port
    server_url = "http://localhost:#{port}/send/testing"

    (testpath/"test_data.txt").write data
    (testpath/"config.json").write <<~JSON
      {
        "interface": "any",
        "fqdn": "localhost",
        "port": #{port}
      }
    JSON

    spawn bin/"qrcp", "-c", testpath/"config.json", "--path", "testing", testpath/"test_data.txt"
    sleep 1

    # User-Agent header needed in order for curl to be able to receive file
    assert_equal data, shell_output("curl -H \"User-Agent: Mozilla\" #{server_url}")
  end
end
