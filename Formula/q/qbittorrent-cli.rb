class QbittorrentCli < Formula
  desc "Command-line interface for qBittorrent written in Go"
  homepage "https://github.com/ludviglundgren/qbittorrent-cli"
  url "https://github.com/ludviglundgren/qbittorrent-cli/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "89342037e76c0877f7ac43530303227b6e15e727153f0415c027ae92af6e4f9e"
  license "MIT"
  head "https://github.com/ludviglundgren/qbittorrent-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aab3e728969af409b2cb3b3a0659302deebbfc4cc88d9038f80fcc64f933cfdf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aab3e728969af409b2cb3b3a0659302deebbfc4cc88d9038f80fcc64f933cfdf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aab3e728969af409b2cb3b3a0659302deebbfc4cc88d9038f80fcc64f933cfdf"
    sha256 cellar: :any_skip_relocation, sonoma:        "241c5c4aedbb49b5f9e56ff34e92d527cce19ecadb4df9dd232d03d6f928484b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "60155a85b2bfdcbdfe2030703ee2da280fdd45d9fc35613145d5a6ba28544891"
    sha256 cellar: :any,                 x86_64_linux:  "233efa4ca5c2e5ff3b7c9067ed2fe515e1f76848337eb366e46b346d639782e2"
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
