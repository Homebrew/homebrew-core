class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.407",
      revision: "485050dcb86b8c1a78e8702efd106f9539ae58dd"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75b2afda75e7955894df5b634c9102ed1a77d1c9d1bc2c7c2b07668fab8e396b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75b2afda75e7955894df5b634c9102ed1a77d1c9d1bc2c7c2b07668fab8e396b"
    sha256 cellar: :any_skip_relocation, monterey:       "3a46e8a59cd3701a4aaa5ebf6355cc109d7a727e46baa176441414fa41fd13f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a46e8a59cd3701a4aaa5ebf6355cc109d7a727e46baa176441414fa41fd13f8"
    sha256 cellar: :any_skip_relocation, catalina:       "3a46e8a59cd3701a4aaa5ebf6355cc109d7a727e46baa176441414fa41fd13f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc4dc5df87f131bdab55f70124e96b86ff601a1cd49066ddc7addf8c60e7558b"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.environment=production
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.version=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("flyctl status 2>&1", 1)
    assert_match "Error No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
