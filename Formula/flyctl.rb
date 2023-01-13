class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.448",
      revision: "c1ce26d9d5085b81560d0556ae354765107c3322"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16166d4b8d9dba0527aa69143a5e262698b52757e04f3722395d332afe651507"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16166d4b8d9dba0527aa69143a5e262698b52757e04f3722395d332afe651507"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16166d4b8d9dba0527aa69143a5e262698b52757e04f3722395d332afe651507"
    sha256 cellar: :any_skip_relocation, ventura:        "96e4e4f133e55e5bc4b52d851474e47e0b9e30df548510136abff608833f769a"
    sha256 cellar: :any_skip_relocation, monterey:       "96e4e4f133e55e5bc4b52d851474e47e0b9e30df548510136abff608833f769a"
    sha256 cellar: :any_skip_relocation, big_sur:        "96e4e4f133e55e5bc4b52d851474e47e0b9e30df548510136abff608833f769a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f696b48fec692aad4355fc648023fff88e59bed11242cdc2dfd918744212ef47"
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
