class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      tag:      "v7.9.1",
      revision: "b965da4f1a2e1d1ca4f1ae1c7396639d56172d1e"
  license "Apache-2.0"
  head "https://github.com/mattermost/mmctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b8da26f89cb8591b8059369acc29aaf7304d343c20140d04ffeea7859517068"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b8da26f89cb8591b8059369acc29aaf7304d343c20140d04ffeea7859517068"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b8da26f89cb8591b8059369acc29aaf7304d343c20140d04ffeea7859517068"
    sha256 cellar: :any_skip_relocation, ventura:        "56cae27003b3078a0951bd3f30b74b8b0b5b4afb3b6cc90a65434b1a0314a5cf"
    sha256 cellar: :any_skip_relocation, monterey:       "56cae27003b3078a0951bd3f30b74b8b0b5b4afb3b6cc90a65434b1a0314a5cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "56cae27003b3078a0951bd3f30b74b8b0b5b4afb3b6cc90a65434b1a0314a5cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1d6a369d2e6ffafb1f942f118a45202c25668d295f3043e0d29b362fce12491"
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
