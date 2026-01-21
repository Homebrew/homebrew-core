class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.6.4.tar.gz"
  sha256 "99da52c3d14c7bd7e528d9e84dbf8e7261a0ef216c8af4cfaf59d173707fb283"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1d8d03a08e910cd72a749e94e8dcb3bb9311c1a4c633866bea97c088d9bf9a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d36e78f555f3cc4cbc8d4fa6bd96e058f52369660283da4762134417d9cbe823"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0202fc6aa99eb01d6c55ab6945343dfca5fcce92175190c13871ade5fc243249"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3c8ceea6e3a91bc742890e9e4e5b75b5d11c51b633925c689f87f405286ed0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5b26765cd0ad503d127f62062ba4bdd9d9e456f2c365eb0da13c7fdbe050d0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df61c5e7563df47ca4b1e99d4056026b6e80f8e69863e3635860fcd3d0ca3e01"
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
