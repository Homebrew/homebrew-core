class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.90",
      revision: "c7497d40cc85d887dfd149b9cac3c675ab624e5a"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd0d52cd4fe9a6756699c7c97a58b865693b87b657e0d4d43b7d6d8762e8863c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd0d52cd4fe9a6756699c7c97a58b865693b87b657e0d4d43b7d6d8762e8863c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd0d52cd4fe9a6756699c7c97a58b865693b87b657e0d4d43b7d6d8762e8863c"
    sha256 cellar: :any_skip_relocation, ventura:        "f4467a741042fcd7f577d62b6f40ccd840eb9a5981a9e52efafdcf59dcba27b7"
    sha256 cellar: :any_skip_relocation, monterey:       "f4467a741042fcd7f577d62b6f40ccd840eb9a5981a9e52efafdcf59dcba27b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4467a741042fcd7f577d62b6f40ccd840eb9a5981a9e52efafdcf59dcba27b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6411a2b5a8462a579659036aeb2e1fba6377b20578343cbee64355901453d555"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
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

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
