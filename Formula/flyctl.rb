class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.484",
      revision: "58efc900f906d2570a00015da50494e794181106"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e3a9bf00c35a8d43116616027a6ff25f583a66caddd9328011419b9901efa79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e3a9bf00c35a8d43116616027a6ff25f583a66caddd9328011419b9901efa79"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e3a9bf00c35a8d43116616027a6ff25f583a66caddd9328011419b9901efa79"
    sha256 cellar: :any_skip_relocation, ventura:        "ea090ebe46e88be3407081638d8e8b0c696e9d7b6f1f93e829568ab972edfcee"
    sha256 cellar: :any_skip_relocation, monterey:       "ea090ebe46e88be3407081638d8e8b0c696e9d7b6f1f93e829568ab972edfcee"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea090ebe46e88be3407081638d8e8b0c696e9d7b6f1f93e829568ab972edfcee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9abe5800e72e672edddf4b98709c4c4eb5903e11f1d4a5bfacc6a545299bae44"
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
