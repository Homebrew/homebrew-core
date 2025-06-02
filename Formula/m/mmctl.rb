class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mattermost"
  url "https://github.com/mattermost/mattermost/archive/refs/tags/v10.8.1.tar.gz"
  sha256 "b7bd6bc791478a931f7a511b6e848c24cbfcd9274edb5d130925a1df1fad136b"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "474413d60682efd2eab55c40d92e51fe840d479e7127746588d207e62b4287c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "474413d60682efd2eab55c40d92e51fe840d479e7127746588d207e62b4287c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "474413d60682efd2eab55c40d92e51fe840d479e7127746588d207e62b4287c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "22a1480b9945fdb258b651b64abc01904a7c670ddef791fb37b3c814e07fd741"
    sha256 cellar: :any_skip_relocation, ventura:       "22a1480b9945fdb258b651b64abc01904a7c670ddef791fb37b3c814e07fd741"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de4ee9e4df76c25b8a0bd5e643be4bca6a36c4dbb0dbfe5ee2db560a049c45e0"
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
