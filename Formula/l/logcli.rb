class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/oss/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.7.9.tar.gz"
  sha256 "374cc8b5f9aab740b44b1b0d9689e69b0e6f2c0feb41942cb52d3e1c4bb7bdeb"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "57124f1fc93eed486dc7a89dd8506c65a050c59f8361acd6fcbe9cb3ce72b3e1"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6c8c271e5b5b7e0845a0fba930dddfa879e4e1733064aa69a92ac26382cad40c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f2a2545a3d42de18b4a4eb44e6b9a023a5efea5fc1804804f551fe7b5a94638e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a35783154251f990c79970113b4d72d6bfd76520f317e7946c72c39c6bd5e68e"
    sha256 cellar: :any,                 x86_64_linux:      "293eb1a770734ff7bb1b056b0d389474301c7032800cb986e30998d39d8b10cd"
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
