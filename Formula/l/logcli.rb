class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.7.0.tar.gz"
  sha256 "8792142f026f40648043029c0553465721997d439e0bfb7beaf3d47fae8b30a5"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6f8833144d341fd972759d63d9515cd1e25b4b3b736dc10b02eb11ccf494ece3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e72c561dffc67da0632a9467949fc1613a1d464137d1b32e1c788911fe30b87f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b45c8d3eeb9c7dcaab6a3853b0e7638e509d099e0724942719a36cc03210718"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4aa323d1752ac8e56218b1e93ff2b429a2f28c1f152c296cbc23c3751db718c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8cceda9f87b58d0e9dfb6399458e020c72ad056e21b909b89391e421660e981d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7d3a919e75f36eeb1e70d297c27235c006945e3c8a0ff970e9bf3246f11dde3"
  end

  depends_on "go" => :build
  depends_on "loki" => :test

  def install
    ldflags = %W[
      -s -w
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
