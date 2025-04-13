class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mattermost"
  url "https://github.com/mattermost/mattermost/archive/refs/tags/v10.6.1.tar.gz"
  sha256 "78fc4e398cb63d11141d2915d12fbd900755eeada7ba5f239d13c2cf053a38b8"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8de32b39dc896d0d23bafb17f981dabdcb3c872ba5e93189a91a07b46cccc21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8de32b39dc896d0d23bafb17f981dabdcb3c872ba5e93189a91a07b46cccc21"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c8de32b39dc896d0d23bafb17f981dabdcb3c872ba5e93189a91a07b46cccc21"
    sha256 cellar: :any_skip_relocation, sonoma:        "24178840a5aefa6a436b92bbbf1464369b7fc14b40120163c6748ffa1cfe112f"
    sha256 cellar: :any_skip_relocation, ventura:       "24178840a5aefa6a436b92bbbf1464369b7fc14b40120163c6748ffa1cfe112f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9dadd79b4de9a5e8955eed7bb66a913b5af71d0930ac9cc5078c68c6a363af4c"
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
