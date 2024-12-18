class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.3.2.tar.gz"
  sha256 "dd2e80ee40b981aaa414f528a76ab218931e5a53d50540e8fb9659f9e2446f43"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2acae0a4a2a7cafc7ff1df9eda82472ecd4e3f5f86bf6162249ef9b0fd8cf844"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eec4425070fc1228d15bade4fde823513cca22e123e754b1320ae6d091624d93"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dc8b2f94dd29de60bbf9368898e0109b31b4c60a9581b6f2ec0d16dabd84dc1f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b189da030fc4355b3c778517b236448a7e95581781544c4167a11723ddcedc6b"
    sha256 cellar: :any_skip_relocation, ventura:       "717b663c2ffe584579f4eb2c2085bd31f020765cbe95af8adb37ba98b7512229"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a9c7784582c1150da95cd7bf7e98b099b3cf35b5b2f95517c7ef5bfb28d052ff"
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
