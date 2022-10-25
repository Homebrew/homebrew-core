class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.420",
      revision: "977028ba41a19da88e55928a2454a23f62dc177f"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2509c747b46b5a56e053a18203ed4d01fee32e822e73474a63985dd11057bf0f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2509c747b46b5a56e053a18203ed4d01fee32e822e73474a63985dd11057bf0f"
    sha256 cellar: :any_skip_relocation, monterey:       "0574125a8975edd6a6bd8d27a97ec695ce1bdeb7427d95bfed4ff8e09b631681"
    sha256 cellar: :any_skip_relocation, big_sur:        "0574125a8975edd6a6bd8d27a97ec695ce1bdeb7427d95bfed4ff8e09b631681"
    sha256 cellar: :any_skip_relocation, catalina:       "0574125a8975edd6a6bd8d27a97ec695ce1bdeb7427d95bfed4ff8e09b631681"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b2993d075f2d8889e206cbd23805c12760d127a07000f0b2eacbf7ad9ff7f9b"
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
