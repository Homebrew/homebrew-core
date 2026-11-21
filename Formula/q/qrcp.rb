class Qrcp < Formula
  desc "Transfer files to and from your computer by scanning a QR code"
  homepage "https://qrcp.sh"
  url "https://github.com/claudiodangelis/qrcp/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "7aba9290ff94a6265f99a85da2c1a94fadcc47d65c40cc172bbaa19ebcc43cc3"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "cd179d7cddcf6694f0c874e2a887c8294578f1e69de6e218ab4e7f5b072cef87"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2245506a6b1b0cb89f7edee65212f2057993007fd9cd136fae05faa11f06d3ee"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2245506a6b1b0cb89f7edee65212f2057993007fd9cd136fae05faa11f06d3ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2245506a6b1b0cb89f7edee65212f2057993007fd9cd136fae05faa11f06d3ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fbbc5f11d3f40742b35c5350587d9d3042684ba4cb191b078f5c89e0894e16c6"
    sha256 cellar: :any,                 x86_64_linux:      "652cf5524f7fa98ffa4f9123f0473e2a62d64578fbfb05479fbd19c490226510"
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
