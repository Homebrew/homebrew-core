class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.6.6.tar.gz"
  sha256 "de62ccf933e49a8db7cd3d375a28c69c2d66b0c2b64432cc6042f9137ad427b1"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11455e320b274e40b196722575a449d964eb62637e9884869f773ea42923a113"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52ba2b895ed1bae7a25b2e2c7c63cc203b1f2b24253f804fdf80024923a66088"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad8c1d2d9da3fcea47958ac2e177c03fd118ac135380655a5c5e332a49e85d2a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c6360ecf4d072dedb1e36dbc4b4dcb03ea1a7892005e140604e9fc2c0bef64e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "751a301bfa7b96b54436f5ba8630e1cb118d0cf68456b1b174cfbcba63389cd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b42ea0cba745284e44f19da43d674affcd826a2b38d32eb1d1d0cd686eefcdf"
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
