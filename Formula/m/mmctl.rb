class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mattermost"
  url "https://github.com/mattermost/mattermost/archive/refs/tags/v11.6.1.tar.gz"
  sha256 "d5876c827542581d2301bcc7d9015ca17b1d7fbb822e4663df0379ab8e895eb0"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "550585187150d135c27982498bc6fa84184e4322d112cadddbd8e3fd7fd3c123"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "550585187150d135c27982498bc6fa84184e4322d112cadddbd8e3fd7fd3c123"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "550585187150d135c27982498bc6fa84184e4322d112cadddbd8e3fd7fd3c123"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf3863e62efc192e178719a9ca6ccba8edada502c0b767148ebfd2427772d8f1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5b49aeda4a3fa4b70cbcdc9b2939f9f990cf3851cdd845166bd134968f11be4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d25dab0040428b200abcd1fb6c8bbd83bd10b101c50a6df310edf7fa6cefefc9"
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
