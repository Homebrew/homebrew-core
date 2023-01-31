class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.451",
      revision: "5a5b5b1fe5793907442b7c57d2f51cdd22baca51"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd55547aef0e82a862e5ff6c2f005646453a44fd17f0984d6fe5dcab337fabbc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd55547aef0e82a862e5ff6c2f005646453a44fd17f0984d6fe5dcab337fabbc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd55547aef0e82a862e5ff6c2f005646453a44fd17f0984d6fe5dcab337fabbc"
    sha256 cellar: :any_skip_relocation, ventura:        "defc8c317cc836e54b1f2bba355392dd692aafb27a98eef065b67a5de4513c88"
    sha256 cellar: :any_skip_relocation, monterey:       "defc8c317cc836e54b1f2bba355392dd692aafb27a98eef065b67a5de4513c88"
    sha256 cellar: :any_skip_relocation, big_sur:        "defc8c317cc836e54b1f2bba355392dd692aafb27a98eef065b67a5de4513c88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f3270b67f014025e07956d7a18f720dba91828b88de7af42b58058f69f4fdba"
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
