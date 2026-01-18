class Mmctl < Formula
  desc "Remote CLI tool for Mattermost server"
  homepage "https://github.com/mattermost/mattermost"
  url "https://github.com/mattermost/mattermost/archive/refs/tags/v11.3.0.tar.gz"
  sha256 "a323edf5a0ce0c9c8584280334e5d658eb86868c882dbd25005bccd1275ed0ed"
  license all_of: ["AGPL-3.0-only", "Apache-2.0"]
  head "https://github.com/mattermost/mattermost.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a0a896b8163709889a49ae8ffbb0a6d4e617891f25e5e86c4eaf9ec34621a31c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0a896b8163709889a49ae8ffbb0a6d4e617891f25e5e86c4eaf9ec34621a31c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0a896b8163709889a49ae8ffbb0a6d4e617891f25e5e86c4eaf9ec34621a31c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e784fa1a3614cc5d7da9eb95d6831e08c82aeb4ac54cb074f1ffeba0f8ab31e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4cb41f51738bd8cd8f0e0cf47f74cedc573986522e5ed7bf76420e64b70f221d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c73d8168e37898bc06cb09bc3e46b8dba6821c50cf2f576f21ec58507ba33064"
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
