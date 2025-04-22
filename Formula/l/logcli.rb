class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.4.3.tar.gz"
  sha256 "00b6b671c1e5fbd52ab1fd014bb8a201d32fe01d9998a28d7dcc933a2c3e5f77"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fb34e4e09e649182fea2c8da986dab2eee85c292251c41b2451f1b2f710e511"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e83e08ba15b0b618587cb75be46566a6ba04e5414faaf0fd8cfd9b20062dd6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f841fc3181aa4b02c4dbefba75413507a346631fbd428bac49607b6301293a8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f86e59617aad899266ed4dcf195ed21890aabf2cdbf48c4b2f9e64326188f4a9"
    sha256 cellar: :any_skip_relocation, ventura:       "bc36d6decf3b73f82f279c361f23cc1974da655ec04745c58d8a8e88d8f61eaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a86ce0c53a35cbf6ef220423f8d519754b94a7e90292ad396e839ea2b75dcc95"
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
