class Qrcp < Formula
  desc "Transfer files to and from your computer by scanning a QR code"
  homepage "https://qrcp.sh"
  url "https://github.com/claudiodangelis/qrcp/archive/refs/tags/v0.11.6.tar.gz"
  sha256 "a3eff505f366713fcb7694e0e292ff2da05e270f9539b6a8561c4cf267ec23c8"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34ee2cedf3dbb46de85b7d6118830450f59a5aaeda93aea898a1d18331415d52"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30cabeb3467581c02c9d1a4927d837fc5ac96b8dea21e9f1b92ce2ee14addecd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30cabeb3467581c02c9d1a4927d837fc5ac96b8dea21e9f1b92ce2ee14addecd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "30cabeb3467581c02c9d1a4927d837fc5ac96b8dea21e9f1b92ce2ee14addecd"
    sha256 cellar: :any_skip_relocation, sonoma:        "2210e68f4eeae23cf63041718cdce05fedbd072ceb434f9f1f1761667091e862"
    sha256 cellar: :any_skip_relocation, ventura:       "2210e68f4eeae23cf63041718cdce05fedbd072ceb434f9f1f1761667091e862"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "796bdc0d75a55864879e3131ac332d3d99af5020bde0ccf0c7229da2aa7c0592"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cedce7a5fa2e8b0c5277bcce76038ca2f03a9eca77673d5636676717cd41134d"
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
