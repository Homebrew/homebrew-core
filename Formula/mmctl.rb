class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      tag:      "v7.10.0",
      revision: "f1e6f1b2394d97cd21e607c16c95bb0cd3c0091c"
  license "Apache-2.0"
  head "https://github.com/mattermost/mmctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bfcb090ed3c0f0a10f701f77b989ca365a805712d31db912ebc0bb2e84f14764"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bfcb090ed3c0f0a10f701f77b989ca365a805712d31db912ebc0bb2e84f14764"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bfcb090ed3c0f0a10f701f77b989ca365a805712d31db912ebc0bb2e84f14764"
    sha256 cellar: :any_skip_relocation, ventura:        "62dc6e9b64f775b14d0d86f78a77c57fd7e0342aa6d5ee7df613718819c1703f"
    sha256 cellar: :any_skip_relocation, monterey:       "62dc6e9b64f775b14d0d86f78a77c57fd7e0342aa6d5ee7df613718819c1703f"
    sha256 cellar: :any_skip_relocation, big_sur:        "62dc6e9b64f775b14d0d86f78a77c57fd7e0342aa6d5ee7df613718819c1703f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1543dba7bbf687ac93826c1c2439099a9c73f0d708c811fed671298ae529eea4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/mattermost/mmctl/commands.BuildHash=#{Utils.git_head}"
    system "go", "build", *std_go_args(ldflags: ldflags), "-mod=vendor"

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
