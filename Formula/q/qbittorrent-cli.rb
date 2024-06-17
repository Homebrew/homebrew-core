class QbittorrentCli < Formula
  desc "Command-line interface for qBittorrent written in Go"
  homepage "https://github.com/ludviglundgren/qbittorrent-cli"
  url "https://github.com/ludviglundgren/qbittorrent-cli/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "91969f22bb167f99091a1ff8f4dbfe61cb1b592cb000453859ca9173ecbb8f10"
  license "MIT"
  head "https://github.com/ludviglundgren/qbittorrent-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2d1c5fb756844c20716657afb77ebe37ee8379482946db1eaef3a9219ef31bf3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b022b67a52e85f8a45704a3fac937b9222ecae032b57d1b28be7d3f7f016431"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4bcac1629bb928fc3b5cbce2d1016a53542e2bbf19fb15e4ca2bf8b122c8878a"
    sha256 cellar: :any_skip_relocation, sonoma:         "6bb9f6e806e31b6af0baf61497d09e3ec9054868d55d0d2bc5d336b5e3ddae98"
    sha256 cellar: :any_skip_relocation, ventura:        "0ca83cbdf66246e6042d1224ead2b9bfa762ba1553b6812940d921dcc634b1c5"
    sha256 cellar: :any_skip_relocation, monterey:       "8c3f597d225f26e14548083ab785a4dbbb4dddf250c919e3cf80dc552a7fba73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b59dc2b5c911a5cf008c32873d5e2799bde307efb789a429dac242a8c350ad40"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"qbt"), "./cmd/qbt"

    generate_completions_from_executable(bin/"qbt", "completion")
  end

  test do
    port = free_port
    (testpath/"config.qbt.toml").write <<~EOS
      [qbittorrent]
      addr = "http://127.0.0.1:#{port}"
    EOS

    output = shell_output("#{bin}/qbt app version --config #{testpath}/config.qbt.toml 2>&1", 1)
    assert_match "could not get app version", output

    assert_match version.to_s, shell_output("#{bin}/qbt version")
  end
end
