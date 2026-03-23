class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.6.7.tar.gz"
  sha256 "28daa4ee3633c8cc45bc6d62a7b470216dc502ff97cac46eb2d5fec228fd498a"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9bd55d022a090bd58fe4522a65025e7becc986b57d8f4df5835ff09f6f6aae3a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57d89faaea2c44d86bef732f65c1b45fd0831c705608272a1000dd6d20af256f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad95d69cabcdc8e2f5652353aa7baa1b4674b12241c8ec30af0292a9e5c71b0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "1f33071b0ff265521b67d4d8cbf6a413dc7c8b44b0c21ebb4999824fb3768805"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ff802e65f6ad1d08895b5ad0a644dfc4bbfd07bd259e7921c70ad922d5c34740"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ef92884ce4e528c4616bacccdaf13ca7c2bcb861abf5c0d485f4f83bd6e154a"
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
