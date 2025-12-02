class QbittorrentCli < Formula
  desc "Command-line interface for qBittorrent written in Go"
  homepage "https://github.com/ludviglundgren/qbittorrent-cli"
  url "https://github.com/ludviglundgren/qbittorrent-cli/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "66b082b4b1653aae785b0f12bc00d7ac4dd8f17028d99e3feafac8aded931957"
  license "MIT"
  head "https://github.com/ludviglundgren/qbittorrent-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8dbb1e0f3009ea428e38774124b3fd34a710fcff9a1f35cdffe613978ca55089"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e89063ee1ee9e114a32ce09eff29422cfb5b50f8a3ed324139e60828ab10123b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e89063ee1ee9e114a32ce09eff29422cfb5b50f8a3ed324139e60828ab10123b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e89063ee1ee9e114a32ce09eff29422cfb5b50f8a3ed324139e60828ab10123b"
    sha256 cellar: :any_skip_relocation, sonoma:        "78d01479e9ca94aa71093187fba7d532eca1057bd9b020bdf0440cb502c1ad0e"
    sha256 cellar: :any_skip_relocation, ventura:       "78d01479e9ca94aa71093187fba7d532eca1057bd9b020bdf0440cb502c1ad0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48f2a2cb1e4cab81c481d4240fc488381faa6ea03e6b1665b4b87e677be4e88e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0949049acfbe454c435d710c62a96ca0651d32108511aefbc1d9f07e6daebc68"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"qbt"), "./cmd/qbt"

    generate_completions_from_executable(bin/"qbt", "completion")
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
