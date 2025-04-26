class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "584d7f45cc85f884e8eb7e8ed8c35eacd2157c6edd0f2a2d0161ba39d22b86ae"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "125a104cd08d4e7aa2a4af5126c43b2d22c914fbc8de5a0768358f47c641835c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d5bd5893bc08627c396a0761c98a3a9171db34bf14b6f50a15954bdb7d77649"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "488967a06f5dcb951c86a91c281e64f23edf059c4409f6e0aa9f050cca30fc62"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b65cce5ef283bb64b058c0ee61c86f6ac2426bf1501cd0aae96f28a3e3684ae"
    sha256 cellar: :any_skip_relocation, ventura:       "a3d1a04e565e67a2eb866bb12e074d328fa3e8a7c9dc3f16207640e3df38cdcd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b12e70b100056f7c668660a1024fedf32a52cde9cae531963b5a19e1a6d2294"
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

    fork { exec Formula["loki"].bin/"loki", "-config.file=loki-local-config.yaml" }
    sleep 3

    assert_empty shell_output("#{bin}/logcli --addr=http://localhost:#{port} labels")
  end
end
