class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.6.0.tar.gz"
  sha256 "0be8473755ad90877f2e0b6ba807ff40d5ddd952dae653b967bff32dc58dd4e7"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f509620c39830a12aeb240ce98ede57acfc937db0df76093f5471db5c70996d0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc880a3bbbfcb1c0dac086d76419bf2d8930e67e217db0a939a284079d983ac6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e54849507defd9816eb16d8e6ef33f5bff9c73df066ba745582ee93d5552d614"
    sha256 cellar: :any_skip_relocation, sonoma:        "104f49153dc2073f546ecbd68ea5f9b74250ec8a41dea6ca31e3285d4889b480"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26f666f4cb3b15d6eb5c60b2a59e0f9b1ac14310ab6489839922c12644b1c2a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6906f25f7517579dc37ec37f66873d6df39f21e627af100a2de509403404360f"
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
