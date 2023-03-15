class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mmctl"
  url "https://github.com/mattermost/mmctl.git",
      tag:      "v7.9.0",
      revision: "56199911e811bb8d96f719049fecc3c64fce9782"
  license "Apache-2.0"
  head "https://github.com/mattermost/mmctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34383355f7a11527528c2ecf5be0a5f1fe12486c6259e7a1cde0b2dbcdd6d6c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34383355f7a11527528c2ecf5be0a5f1fe12486c6259e7a1cde0b2dbcdd6d6c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34383355f7a11527528c2ecf5be0a5f1fe12486c6259e7a1cde0b2dbcdd6d6c4"
    sha256 cellar: :any_skip_relocation, ventura:        "c9cb042f9a5d01f8bfddd768df669a83a8f365a1f93ff011e947c66b58925f78"
    sha256 cellar: :any_skip_relocation, monterey:       "c9cb042f9a5d01f8bfddd768df669a83a8f365a1f93ff011e947c66b58925f78"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9cb042f9a5d01f8bfddd768df669a83a8f365a1f93ff011e947c66b58925f78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2df3f65d5a37ea2ee6520d713e6c3e5803cf48e68309619493742feaac034ad6"
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
