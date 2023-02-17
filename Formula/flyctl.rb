class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.462",
      revision: "2090b10783a0dc61d1e244e509a86a448a295707"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f51b33e6dbb65e99bad0afc67ab8ee33f29e9f8a0a7805a1a18eeaba33a63eac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f51b33e6dbb65e99bad0afc67ab8ee33f29e9f8a0a7805a1a18eeaba33a63eac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f51b33e6dbb65e99bad0afc67ab8ee33f29e9f8a0a7805a1a18eeaba33a63eac"
    sha256 cellar: :any_skip_relocation, ventura:        "756361571cccd84f4ce0fcc95039536c558fdc2600868ef3cb61a3b32e1aa139"
    sha256 cellar: :any_skip_relocation, monterey:       "756361571cccd84f4ce0fcc95039536c558fdc2600868ef3cb61a3b32e1aa139"
    sha256 cellar: :any_skip_relocation, big_sur:        "756361571cccd84f4ce0fcc95039536c558fdc2600868ef3cb61a3b32e1aa139"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12f9105063cf490c9eac65bbd5aef7c55ae180db4d13c8744931ad92e5b85f68"
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
