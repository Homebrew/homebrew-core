class Qrcp < Formula
  desc "Transfer files to and from your computer by scanning a QR code"
  homepage "https://qrcp.sh"
  url "https://github.com/claudiodangelis/qrcp/archive/refs/tags/v0.11.4.tar.gz"
  sha256 "d8f860a22fd0a1a450b6f5c449cf4c10a47f1c70ae0196898f866bb7618ec6c7"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c60d772f6858493e7cf3b1f32e29fa634dece4a22624df5ae6d2ba93172025b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c60d772f6858493e7cf3b1f32e29fa634dece4a22624df5ae6d2ba93172025b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c60d772f6858493e7cf3b1f32e29fa634dece4a22624df5ae6d2ba93172025b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "23786e9d1e6633643a2ff886208d483a2da9944bf5adcf0b23c7e01107ae5a33"
    sha256 cellar: :any_skip_relocation, ventura:       "23786e9d1e6633643a2ff886208d483a2da9944bf5adcf0b23c7e01107ae5a33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f9e828594359fe1fe0ba1ef8ac8390c0969190dbbc622afe2960dbc26f66fbd"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/claudiodangelis/qrcp/version.version=#{version}
      -X github.com/claudiodangelis/qrcp/version.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"qrcp", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/qrcp version")

    (testpath/"test_data.txt").write <<~EOS
      Hello there, big world
    EOS

    port = free_port
    server_url = "http://localhost:#{port}/send/testing"

    (testpath/"config.json").write <<~JSON
      {
        "interface": "any",
        "fqdn": "localhost",
        "port": #{port}
      }
    JSON

    fork do
      exec bin/"qrcp", "-c", testpath/"config.json", "--path", "testing", testpath/"test_data.txt"
    end
    sleep 1

    # User-Agent header needed in order for curl to be able to receive file
    assert_equal "Hello there, big world\n", shell_output("curl -H \"User-Agent: Mozilla\" #{server_url}")
  end
end
