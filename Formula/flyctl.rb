class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.404",
      revision: "c60b0a0bf953f3d7eb89c7ce6eb8d50a3b6b5c55"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d11645cddfff6ade2fdf44410cd2a575b6ec661829aaf75ef789b24745dbf601"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d11645cddfff6ade2fdf44410cd2a575b6ec661829aaf75ef789b24745dbf601"
    sha256 cellar: :any_skip_relocation, monterey:       "35242f409f4688dd8549d9747400b5eec15a5579c0ddec62310486bc27c2df10"
    sha256 cellar: :any_skip_relocation, big_sur:        "35242f409f4688dd8549d9747400b5eec15a5579c0ddec62310486bc27c2df10"
    sha256 cellar: :any_skip_relocation, catalina:       "35242f409f4688dd8549d9747400b5eec15a5579c0ddec62310486bc27c2df10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "58fa1d94ed8f423eda87201ff74e00ee55a82170f6b6cf26bb95431395010e6b"
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
