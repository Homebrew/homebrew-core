class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/oss/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.7.7.tar.gz"
  sha256 "e2e8863c15ad97a4649a6f0795d549a8977e44f4413e2b001e6eb0c12c22eb9c"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "742d68ae76b41e2924268532bd1d54860dad77392f7f5a2d35b7b81ff56da230"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4b684ea41575dfcd24408d5e31def521be4aef604ceae8120aba7f482c7c2d60"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dbe3979cb8530c6c914c7d892a2530faaeab8523d8d60f0faf2deae3796a2e04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "3450cba9e453a6978d86fe44dc4b973f427384477f7a1b284b1fd014223b55b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "162ee00d38cd7b3cc161488b66cea64e53dd8845d422a25799824d3ca316eece"
    sha256 cellar: :any,                 x86_64_linux:      "1d55b28c1f9207d3cac3afbb8282891612c4c538e07db16b184dd294e01c6203"
  end

  depends_on "go" => :build
  depends_on "loki" => :test

  # `test do` block runs a local loki server
  deny_network_access! [:build, :postinstall]

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/grafana/loki/pkg/util/build.Branch=main
      -X github.com/grafana/loki/pkg/util/build.Version=#{version}
      -X github.com/grafana/loki/pkg/util/build.BuildUser=#{tap.user}
      -X github.com/grafana/loki/pkg/util/build.BuildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/logcli"

    generate_completions_from_executable(
      bin/"logcli",
      shell_parameter_format: "--completion-script-", shells: [:bash, :zsh],
    )
  end

  test do
    resource "homebrew-testdata" do
      url "https://raw.githubusercontent.com/grafana/loki/5c8542036609f157fee45da7efafbba72308e829/cmd/loki/loki-local-config.yaml"
      sha256 "14557cd65634314d4eec22cf1bac212f3281854156f669b61b17f2784c895ab1"
    end

    port = free_port

    testpath.install resource("homebrew-testdata")
    inreplace "loki-local-config.yaml" do |s|
      s.gsub! "3100", port.to_s
      s.gsub! "/tmp", testpath
    end

    spawn Formula["loki"].bin/"loki", "-config.file=loki-local-config.yaml"
    sleep 3

    assert_empty shell_output("#{bin}/logcli --addr=http://localhost:#{port} labels")
  end
end
