class QbeeCli < Formula
  desc "Command-line tool and Golang library for managing Qbee devices"
  homepage "https://qbee.io/"
  url "https://github.com/qbee-io/qbee-cli/archive/refs/tags/v1.2025.7.tar.gz"
  sha256 "13977c8ef7f48d2ee7c89362cec16be9d957cd0b955af36f0804c02ebcfcf9f3"
  license "Apache-2.0"
  head "https://github.com/qbee-io/qbee-cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X go.qbee.io/client.Version=v#{version}
    ].join(" ")

    system "go", "build", *std_go_args(ldflags: ldflags, output: bin/"qbee-cli"), buildpath/"cmd"
  end

  test do
    system bin/"qbee-cli", "version"
    expected_version = "v1.2025.7"
    actual_version = shell_output("#{bin}/qbee-cli version").strip
    assert_equal expected_version, actual_version
  end
end
