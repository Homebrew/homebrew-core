class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      tag:      "v7.10.3",
      revision: "f2c2279df28f0b9ae76ef9e4dd7fcdd85470ee3a"
  license "Apache-2.0"
  head "https://github.com/mattermost/mmctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30371da4285e2af8a1cb7638f04ada6837a8f6eae9bfa9a3591efb58eab3024d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30371da4285e2af8a1cb7638f04ada6837a8f6eae9bfa9a3591efb58eab3024d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30371da4285e2af8a1cb7638f04ada6837a8f6eae9bfa9a3591efb58eab3024d"
    sha256 cellar: :any_skip_relocation, ventura:        "dc50e765d7b531612cb618f8cb49ba6d0bd7382dda5734c32a2ca0d571ce56ab"
    sha256 cellar: :any_skip_relocation, monterey:       "dc50e765d7b531612cb618f8cb49ba6d0bd7382dda5734c32a2ca0d571ce56ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc50e765d7b531612cb618f8cb49ba6d0bd7382dda5734c32a2ca0d571ce56ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe22279a8efae210937ae15f6c934b86a446a494c517880741cd79aa346820ee"
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
