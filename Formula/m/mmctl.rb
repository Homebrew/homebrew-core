class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mattermost"
  url "https://github.com/mattermost/mattermost/archive/refs/tags/v10.9.1.tar.gz"
  sha256 "b660efa723992ebf3edf24fc2d7024b5deae57a165f0c02ae27b4a4c41413408"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9128a26ccb75b4599050f20c559f722a8d62511d5bc323570cb1c1185ed5c042"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9128a26ccb75b4599050f20c559f722a8d62511d5bc323570cb1c1185ed5c042"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9128a26ccb75b4599050f20c559f722a8d62511d5bc323570cb1c1185ed5c042"
    sha256 cellar: :any_skip_relocation, sonoma:        "a6a96cb17df53da75d535b9c0feedae4b517533b79dbce6c8f22b1867ab86d37"
    sha256 cellar: :any_skip_relocation, ventura:       "a6a96cb17df53da75d535b9c0feedae4b517533b79dbce6c8f22b1867ab86d37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43a2d93789c37a09522ef9b061ca2596e899ebed35294d807d06f8809306836d"
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
