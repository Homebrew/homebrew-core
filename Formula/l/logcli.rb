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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c65a3d708f5df8581d232429f24c35644681d2ad09dc76c15953fafb990f8b78"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd1c32673d0a1a1e35423237c59d2689e29e5cd80364dce84eef4341fe609146"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "673798ba2bc7fa80b0be29ef4b7b34890d7d40f170add8713ac0060f672b139d"
    sha256 cellar: :any_skip_relocation, sonoma:        "18a3bc9b05ee551ecbda8e9c5fea07d7bbf769043b33148859af1362d6b8260a"
    sha256 cellar: :any_skip_relocation, ventura:       "3cc7cd2448472a691abc26531851e4c161a8a9e24df56ee9e6ead2ac2f99d5bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aabccb0778a7cc4b108d27be9f9ec6dbf219377aca036aca4908f979d80802c5"
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
