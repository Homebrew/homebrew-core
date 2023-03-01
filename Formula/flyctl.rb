class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.473",
      revision: "f721dccfa00fbe3a9b95090b3d9f95d63de5da78"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62afc0d2b2dfc44318070e450e07aa91718db3130d0b653b8ec575c4f698c10d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62afc0d2b2dfc44318070e450e07aa91718db3130d0b653b8ec575c4f698c10d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62afc0d2b2dfc44318070e450e07aa91718db3130d0b653b8ec575c4f698c10d"
    sha256 cellar: :any_skip_relocation, ventura:        "7a22d3bb0d67afa6aac72d206bdf4d63c8837448bb8165f2ce4ccd0df2dccaac"
    sha256 cellar: :any_skip_relocation, monterey:       "7a22d3bb0d67afa6aac72d206bdf4d63c8837448bb8165f2ce4ccd0df2dccaac"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a22d3bb0d67afa6aac72d206bdf4d63c8837448bb8165f2ce4ccd0df2dccaac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bc2b661625dd6e7c48007aed6c80a3e441412a4524a0ea46ea705dd6f37d7b8"
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

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
