class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.6.2.tar.gz"
  sha256 "6ebcd323959fcc6b6ec5a466c5a6c975d186c9c3a81b61f3c69cdc8b047c1961"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "29cd9c81b5b7bc993674e79b82b07d521e0b5308830a0fae53d1555dcce2a2ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fa1c53b95c796c44e24ad024cb897947e9e4745089ba1eea35acec3450e0ca99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2440031d94ce46c7d2a20c84bd84c9ca9d5455eba2a84d4bfadaa08ac63a799"
    sha256 cellar: :any_skip_relocation, sonoma:        "3231a389677ad48b7bb4b959af98c834ca5812004de5780854b11610c6d09742"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84607c8015ab71a5ed5405b67d49cdaa6fac092e25e70aa7c24f108548620b1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a8a555818d808e5bb1a5f065f0b89d72c739a4d13eec9e80c7854820f0c4708"
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
