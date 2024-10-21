class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.2.1.tar.gz"
  sha256 "4d39632d6cb60a3252ca294558aa7eff2c9bb4b66b62920f4691389d293b6d7b"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91a38a8024fd755d995873f7a5eddc88255790144d0f5f2ccbfe57578f3840cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a5de9710b1aa6deb984b8be9cfdb1eec83599f4b2f9a37b44207af62b5a60bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7965ad074ba14d28f2e3381d2dec77d83b0815b0b04392b1b9c3f24683cae26e"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e8025adae69e3ac4614551bcb3088268e6ceb5d690c449ecdf686cda7d37484"
    sha256 cellar: :any_skip_relocation, ventura:       "2ab8669512e90b4d0e4fbfde4104c3fa506f53cd55d5e85423dd026d02f6f00d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b554ee9a8426339a8120531140e6c82335023322bb42c183dfe44a5907f1463"
  end

  depends_on "go" => :build
  depends_on "loki" => :test

  def install
    ldflags = %W[
      -s -w
      -X github.com/grafana/loki/pkg/util/build.Branch=main
      -X github.com/grafana/loki/pkg/util/build.Version=#{version}
      -X github.com/grafana/loki/pkg/util/build.BuildUser=homebrew
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
      url "https://raw.githubusercontent.com/grafana/loki/b286075428a6cc7f58040bbdec6c81a97b626852/cmd/loki/loki-local-config.yaml"
      sha256 "2526c97ba82915499d134d8fb6f3dad2828065531818ff94798b36cd9a59e8e2"
    end

    port = free_port

    testpath.install resource("homebrew-testdata")
    inreplace "loki-local-config.yaml" do |s|
      s.gsub! "3100", port.to_s
      s.gsub! "/tmp", testpath
    end

    fork { exec Formula["loki"].bin/"loki", "-config.file=loki-local-config.yaml" }
    sleep 3

    assert_empty shell_output("#{bin}/logcli --addr=http://localhost:#{port} labels")
  end
end
