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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7a8bbc5ad237bf97d73501062a2f1e30d7ce8a5b9a38912f6ffb158370c96a8e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7a8bbc5ad237bf97d73501062a2f1e30d7ce8a5b9a38912f6ffb158370c96a8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7a8bbc5ad237bf97d73501062a2f1e30d7ce8a5b9a38912f6ffb158370c96a8e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ffc63e2c7d66b1e1faedb36c2df428c712fb5852f1d88d55c7ed80bb7b18bb2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a37b2bba75a20fd96c2dc6754444afb0bb152258e869d855644fa5bebb185a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d18ce31b0d751e4fffb64ecbac9d20fcb3bcda31877ca6de1950070fa3c06c91"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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
