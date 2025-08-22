class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mattermost"
  url "https://github.com/mattermost/mattermost/archive/refs/tags/v10.11.2.tar.gz"
  sha256 "17aa396db23d949ee74703be8056c3c1c645e7f4ecd1e3433190e4be0c18750c"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78253a7a7113101feff7b43024395c263d52fc5637f7bab31cfc1aecd830979f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78253a7a7113101feff7b43024395c263d52fc5637f7bab31cfc1aecd830979f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "78253a7a7113101feff7b43024395c263d52fc5637f7bab31cfc1aecd830979f"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc7881b6f1d3ac1e867b690c8f2e83aad730c44494d8bd65124a784797c63523"
    sha256 cellar: :any_skip_relocation, ventura:       "cc7881b6f1d3ac1e867b690c8f2e83aad730c44494d8bd65124a784797c63523"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cc778b414a67524ed6e113ca1176c77e3e1528f4ac68502445280cd8e4a9a1f"
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
