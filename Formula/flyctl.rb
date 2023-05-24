class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.12",
      revision: "b0911e043fbfb315d5a924d7f3ad4ed673967a22"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e17e7f479054e66bf781034796484a790c15cce91de6fbef42bcc8eff2347bcc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e17e7f479054e66bf781034796484a790c15cce91de6fbef42bcc8eff2347bcc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e17e7f479054e66bf781034796484a790c15cce91de6fbef42bcc8eff2347bcc"
    sha256 cellar: :any_skip_relocation, ventura:        "05dc6a4ea72f58b9b96123d731560820bd42cf40269e2c0cdc6400720d485e50"
    sha256 cellar: :any_skip_relocation, monterey:       "05dc6a4ea72f58b9b96123d731560820bd42cf40269e2c0cdc6400720d485e50"
    sha256 cellar: :any_skip_relocation, big_sur:        "05dc6a4ea72f58b9b96123d731560820bd42cf40269e2c0cdc6400720d485e50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b5f1705c7a13482e66497c096c1638f26b10d1edbb8d13a2099c054ebe4cde9"
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
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
