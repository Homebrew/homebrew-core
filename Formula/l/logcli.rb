class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.6.1.tar.gz"
  sha256 "92fb716bf68a7e6ab6cd65b75929f3a32c10344a2426a8b113a3b0d195020a28"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "040fa2f2e8bcf8339fbc00dd4cbee03a190e32616604a18e90cc209dfa3f6f35"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6a9f766cb094244e66ede649d48a6fc2c2644b339b8cc774dc3ca6040e18208a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b97142ade9365a9223814b74357ebeebf4ede99b2ce619431c7a36b9b2ac10a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "7c567ac20d9238753f0d8e7c02b59a714fc14f209ca0899bc21e775a8e288ccc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47660470ad406b1bc5606d5c2ea221f3d038fe2750d05f6566d0cb79b1c47aee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c62a1594c330b21c1234c9ff1a08c3fd4eab8abf27ea355669edf4a755dc4f9b"
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
