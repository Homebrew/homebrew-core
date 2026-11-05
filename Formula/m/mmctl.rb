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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4afbaefc1ea1716076a1c004dbb4e398949c313c9448d3bb1a51c8f4ff3f811e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4afbaefc1ea1716076a1c004dbb4e398949c313c9448d3bb1a51c8f4ff3f811e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4afbaefc1ea1716076a1c004dbb4e398949c313c9448d3bb1a51c8f4ff3f811e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "22628b1834aaced23e5a7b7786dbda7094936edcdf738d7b549feb787e980db8"
    sha256 cellar: :any,                 x86_64_linux:      "cdf16feb1b3ae8c63fbdf0af86ad8824ce986fb80dc55a6e3ac53a64602a42b5"
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
