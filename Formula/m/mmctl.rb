class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mattermost"
  url "https://github.com/mattermost/mattermost/archive/refs/tags/v11.1.1.tar.gz"
  sha256 "70a4ebc55ec6f54d12e293ca8fa38a796ce7cc80a9459da9cb28a38d7f76763a"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "500805911763bc7ccc3a00af0feb70c31feba1d0b93f27cdbd4ac7e39cb00f51"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "500805911763bc7ccc3a00af0feb70c31feba1d0b93f27cdbd4ac7e39cb00f51"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "500805911763bc7ccc3a00af0feb70c31feba1d0b93f27cdbd4ac7e39cb00f51"
    sha256 cellar: :any_skip_relocation, sonoma:        "d800289d7204112240f3630215aa59561323f9c9d7c2fa2831d6fab04ce9bf9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e4c83c8cdc57c43e4dbe6388bb67186b7630af4d498e6a3fc350d90a9b9a62f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "184e96cf8da2666b05da41f20208f5e478d749a158dc73f8194b2ca426244836"
  end

  depends_on "go" => :build

  def install
    # remove non open source files
    rm_r("server/enterprise")
    rm Dir["server/cmd/mmctl/commands/compliance_export*"]

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
