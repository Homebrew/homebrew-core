class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.492",
      revision: "703500145f7fed002f316e800edbb172f3425716"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5cd0f5c231f04c33c70347fbd7f8eaa4e2e99bc4f6060a98cee33f8cfbf1904"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5cd0f5c231f04c33c70347fbd7f8eaa4e2e99bc4f6060a98cee33f8cfbf1904"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5cd0f5c231f04c33c70347fbd7f8eaa4e2e99bc4f6060a98cee33f8cfbf1904"
    sha256 cellar: :any_skip_relocation, ventura:        "4f0f0e4df283c0fac1ff4e0f1a4422b3e996e8eb7f88baa8728a99fadc67b0e5"
    sha256 cellar: :any_skip_relocation, monterey:       "4f0f0e4df283c0fac1ff4e0f1a4422b3e996e8eb7f88baa8728a99fadc67b0e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f0f0e4df283c0fac1ff4e0f1a4422b3e996e8eb7f88baa8728a99fadc67b0e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfbfbe5c891b12bd03bcd95e87c1aca24996547520b295f3a7332cd1d07f0824"
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
