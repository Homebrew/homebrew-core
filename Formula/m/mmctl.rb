class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://mattermost.com"
  url "https://github.com/mattermost/mattermost/archive/refs/tags/v12.0.2.tar.gz"
  sha256 "103300083e8f49e4cec48e270f1b3922d69461e8e89bd36a8ab53af3bdc59b55"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "16cd97144112f2e900e3f50d74e06bf16fd664f9e48618b58720008dce03bd26"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "16cd97144112f2e900e3f50d74e06bf16fd664f9e48618b58720008dce03bd26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "16cd97144112f2e900e3f50d74e06bf16fd664f9e48618b58720008dce03bd26"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d8df91d1567990ba633e5f49a66991c1f074ce6144528f71ec87b706df483051"
    sha256 cellar: :any,                 x86_64_linux:      "f638a1194874fba3c3a3cca21bede7918b1ce1755ffaed43b5e2bd386134545c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "make", "-C", "server", "setup-go-work"
    system "go", "mod", "download", "-C", "server"
  end

  def install
    # remove non open source files
    rm_r("server/enterprise")
    rm Dir["server/cmd/mmctl/commands/compliance_export*"]

    ldflags = "-X github.com/mattermost/mattermost/server/v8/cmd/mmctl/commands.buildDate=#{time.iso8601}"
    system "make", "-C", "server", "setup-go-work"
    system "go", "build", "-C", "server", *std_go_args(ldflags:), "./cmd/mmctl"

    # Install shell completions
    generate_completions_from_executable(bin/"mmctl", "completion", shells: [:bash, :zsh])
  end

  test do
    output = pipe_output("#{bin}/mmctl help 2>&1")
    refute_match(/.*No such file or directory.*/, output)
    refute_match(/.*command not found.*/, output)
    assert_match(/.*mmctl \[command\].*/, output)
  end
end
