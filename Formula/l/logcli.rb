class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.7.1.tar.gz"
  sha256 "05c5d23eff751b9c4f4e49918359e35b7ba840a5b504e3eac0befe4ad94ad464"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bfe2fea228443d3d796b0061680d5903f861f0f8f447e01c29e2e6559f24bdcd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a24b7aededb9167e57cb803bd561530c465cdba2dfcc32fccd537743a43dc494"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "633477bef0fd1490fb3f556582cdd343fc383ca298027a5cb30f7857003fc94a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3240eba659ca307728cda2127b8b90672782bb7cd65fe43ad7507b18f4c1e9c6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c806513fc642bf34cb9c42af4d0e8df3c7ac438868368c9d11103b5b85bb2abe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12da5cff92d3fa01bd18b62815471e44239e62c43f682c4bc7fb25de64dcacdb"
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
