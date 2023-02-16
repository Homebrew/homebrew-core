class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.458",
      revision: "bf6a2deb56e3bcdd4fb1c9d7b0ae6c8760830009"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95e540e2aa3f973299452b57666a4e3367f2928d825a40d0aaa8b0fa6e22a51e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95e540e2aa3f973299452b57666a4e3367f2928d825a40d0aaa8b0fa6e22a51e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95e540e2aa3f973299452b57666a4e3367f2928d825a40d0aaa8b0fa6e22a51e"
    sha256 cellar: :any_skip_relocation, ventura:        "bb5e9a931d9c17a46c0e7659f37028418b563efef28784284622b6bf6d11ac8f"
    sha256 cellar: :any_skip_relocation, monterey:       "bb5e9a931d9c17a46c0e7659f37028418b563efef28784284622b6bf6d11ac8f"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb5e9a931d9c17a46c0e7659f37028418b563efef28784284622b6bf6d11ac8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54b2579a891afc56ffcd07c9c7e704d74db2fc00aa5705aece61a897d8aca619"
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
