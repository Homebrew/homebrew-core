class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/oss/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.7.11.tar.gz"
  sha256 "f4aba5fa2867d60e77f08b0d9e7d65bfae79502bb85c8b56aa22206b2d3cc3d8"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    manifest_sha256 "00b4abe32980dc0153b0e96770e10642182970b067672c63c8f42b5e85014b33"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d5bbd72adfa3c2f69beaa3aada6af031ecc0dd937295ed267178e188b4aa8961"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b79e71854c142c2782a47ef39bd434fecb4379c4b7d55d37d582f4fa0c4a23a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d6675992ee6f89e79bc7eb296b5393e66c610201aac04adb4ec85bcaf9570d8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0c33029aa7f066e2e1e494312a9bf7c4397b5411e8bfe1c66c8732d29dc299f1"
    sha256 cellar: :any,                 x86_64_linux:      "40c57f3295dc05a52c023863f0b21db101a029b841696bb63e620456546fb657"
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
