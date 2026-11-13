class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/oss/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.7.10.tar.gz"
  sha256 "52e1a821de73d634a152e6737f7a4629dae830240015a2d6f244ccaaf3b13357"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d454d90279296ea8caa487a10c634cf70f03775baff942523ab605065b27776c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fd0557a36ffdf9d910ebb10583d3f978488d9ed8b825f8f70da2526f5891bb9d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b7c646c669929eccb0a7c9324c0d0a4c5bc412440b7e4344ce97c2f645e7d979"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "88de6a46f2ad7accc639248a92165949ea770364907aa5e860fdb2d5c0bbace9"
    sha256 cellar: :any,                 x86_64_linux:      "6ae17e66f068756d8fc42181babad604f041200d9ab46fe19dd23b0794f29778"
  end

  depends_on "go" => :build
  depends_on "loki" => :test

  resource "homebrew-testdata", :test do
    url "https://raw.githubusercontent.com/grafana/loki/5c8542036609f157fee45da7efafbba72308e829/cmd/loki/loki-local-config.yaml"
    sha256 "14557cd65634314d4eec22cf1bac212f3281854156f669b61b17f2784c895ab1"
  end

  # `test do` block runs a local loki server
  allow_network_access! :test

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
    port = free_port

    testpath.install resource("homebrew-testdata")
    inreplace "loki-local-config.yaml" do |s|
      s.gsub! "3100", port.to_s
      s.gsub! "/tmp", testpath
    end

    spawn formula_opt_bin("loki")/"loki", "-config.file=loki-local-config.yaml"
    sleep 3

    assert_empty shell_output("#{bin}/logcli --addr=http://localhost:#{port} labels")
  end
end
