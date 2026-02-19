class QbittorrentCli < Formula
  desc "Command-line interface for qBittorrent written in Go"
  homepage "https://github.com/ludviglundgren/qbittorrent-cli"
  url "https://github.com/ludviglundgren/qbittorrent-cli/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "66b082b4b1653aae785b0f12bc00d7ac4dd8f17028d99e3feafac8aded931957"
  license "MIT"
  head "https://github.com/ludviglundgren/qbittorrent-cli.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "716525b58fbeb4067f489a3eb10428012b3fa9bcf3210a8054cae07778378e1e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "716525b58fbeb4067f489a3eb10428012b3fa9bcf3210a8054cae07778378e1e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "716525b58fbeb4067f489a3eb10428012b3fa9bcf3210a8054cae07778378e1e"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e5efce627c5e7478eea9103fb6d7804785d5596b666f00603d7d5ea89ee28dd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "800339a3ae35a1ce3a8e523a5da78433475910b71186386a212ae4705928d3d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "beba3400eaf3260e34176efee850cd40f05ccb387156640327aa0495db3b9b7c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"qbt"), "./cmd/qbt"

    generate_completions_from_executable(bin/"qbt", shell_parameter_format: :cobra)
  end

  test do
    port = free_port
    (testpath/"config.qbt.toml").write <<~TOML
      [qbittorrent]
      addr = "http://127.0.0.1:#{port}"
    TOML

    output = shell_output("#{bin}/qbt app version --config #{testpath}/config.qbt.toml 2>&1", 1)
    assert_match "could not get app version", output

    assert_match version.to_s, shell_output("#{bin}/qbt version")
  end
end
