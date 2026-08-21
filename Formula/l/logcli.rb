class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/oss/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.7.6.tar.gz"
  sha256 "0dd21abbe613ff51807e4e58cafe4ce71dd1561396c4dc7eb4d7f7e8f577baf1"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea1b1d50cf8ed3e4b7719f9183f5682616b3066768027d6ab399608b76282cd0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a41b7586ed73441e5a2a76a48a0c78d9cebb4305ed773ecd258ef9e005ebe87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e69f9cd29e94351dd82f3ae2dba19f3e242f5da87464c014747a5f3666f704b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d42a8688ab1895a8bf6ca2b753ef355bfe2848a54783317392916d7d5d7b41fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0e6566ea5a035657818ba3bd395c29a5d788607014b2ec3d4470ec15f5bf649"
    sha256 cellar: :any,                 x86_64_linux:  "042e18f7acb1bdb29dbb5aae494964c768d777cd2e82b94f6e4c4bf5c09ca966"
  end

  depends_on "go" => :build
  depends_on "loki" => :test

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
