class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mattermost"
  url "https://github.com/mattermost/mattermost/archive/refs/tags/v10.7.1.tar.gz"
  sha256 "3aa9549a007f91ba9687f046e91c38402f0774a2a042117d6b574d99896a93b4"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "208eede62d9e172e27de1dbb4131c0601ec0db27438691968ffb9d0510d523f6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "208eede62d9e172e27de1dbb4131c0601ec0db27438691968ffb9d0510d523f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "208eede62d9e172e27de1dbb4131c0601ec0db27438691968ffb9d0510d523f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "c96ddd2e66a7441f0f1509ad9c945a51841ba728dd7f2adf239b0547c9bce648"
    sha256 cellar: :any_skip_relocation, ventura:       "c96ddd2e66a7441f0f1509ad9c945a51841ba728dd7f2adf239b0547c9bce648"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6220d5892eb657d803fce0b5dfebe21f6cd6f1b81d9926bacdd6b405e30c263f"
  end

  depends_on "go" => :build

  def install
    # remove non open source files
    rm_r("server/enterprise")

    ldflags = "-s -w -X github.com/mattermost/mattermost/server/v8/cmd/mmctl/commands.buildDate=#{time.iso8601}"
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
