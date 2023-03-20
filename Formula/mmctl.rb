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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e98998af59322d4e553221a3e273efcf9204954ff7c50f9949f0dd491dacb57"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e98998af59322d4e553221a3e273efcf9204954ff7c50f9949f0dd491dacb57"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e98998af59322d4e553221a3e273efcf9204954ff7c50f9949f0dd491dacb57"
    sha256 cellar: :any_skip_relocation, ventura:        "e0193b718d6e877aed4fde17b9e7960a78c3fb15ab2b25af136d19040469e4a1"
    sha256 cellar: :any_skip_relocation, monterey:       "e0193b718d6e877aed4fde17b9e7960a78c3fb15ab2b25af136d19040469e4a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0193b718d6e877aed4fde17b9e7960a78c3fb15ab2b25af136d19040469e4a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dccf23babd5178b334ca09fce6da6f44d89bf2cc739919688aabed35e111349c"
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
