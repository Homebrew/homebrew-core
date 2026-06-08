class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.7.2.tar.gz"
  sha256 "f91b7737cc0ca352dfb99e9307bc2f6a67135d6827922374ab4a31676d280790"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c7bb7e4bfd4c57ebaa6d2a61d3d8c31e84a1e893d4898b0b989f7883b3c56a4d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8c9d6d13aac45ed7c176525727fc201bf0d9c674962cafeef432daa6d1de7e04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91266473d3b8d9e346f44d60963a1bfb9ff66ff58d9fae52cbf21ae794f6d62c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a176ef53c33f1939fa3281dd6b16e97d5546702de7e35c98cdf4a3398d275ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a25ea9011f312f19e74db7488b1dd7b73d876532671f91293e145f8b60442a5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60158271c85ca816e64c98caedf00b693435a21c512ef61c7c08ffe404161e97"
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
