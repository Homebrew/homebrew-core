class QbittorrentCli < Formula
  desc "Command-line interface for qBittorrent written in Go"
  homepage "https://github.com/ludviglundgren/qbittorrent-cli"
  url "https://github.com/ludviglundgren/qbittorrent-cli/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "2b78d5e8531aa54d0b01b801aea3b78da4a4932d65e4243cdf3209a68bb80777"
  license "MIT"
  head "https://github.com/ludviglundgren/qbittorrent-cli.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e96b29807392f7c74e501cd2f719318d3e770ec2b8876cd227e423533383c69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e96b29807392f7c74e501cd2f719318d3e770ec2b8876cd227e423533383c69"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e96b29807392f7c74e501cd2f719318d3e770ec2b8876cd227e423533383c69"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3d31377614b1fb573a91e316f8f87609bb3b1187c5eef077e8ef1be12548164"
    sha256 cellar: :any_skip_relocation, ventura:       "f3d31377614b1fb573a91e316f8f87609bb3b1187c5eef077e8ef1be12548164"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "318e10b9ca3a6e4ae318c4588473da21110f6e7dfaeca1354ce3f634341687e5"
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
