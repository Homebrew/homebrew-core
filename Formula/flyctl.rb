class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.31",
      revision: "e2b55f1a9fbe2201ca12f621fef02a47ca2dfcae"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2cfc84d7afc355918bb1d1c1c17990705b6d7bfe7549187d58f09b3538b599b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2cfc84d7afc355918bb1d1c1c17990705b6d7bfe7549187d58f09b3538b599b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2cfc84d7afc355918bb1d1c1c17990705b6d7bfe7549187d58f09b3538b599b"
    sha256 cellar: :any_skip_relocation, ventura:        "90981c9ec87fbf3856177b1cf49ca0f6c34ccd8bcbdd6f7f2a134f10412764b8"
    sha256 cellar: :any_skip_relocation, monterey:       "90981c9ec87fbf3856177b1cf49ca0f6c34ccd8bcbdd6f7f2a134f10412764b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "90981c9ec87fbf3856177b1cf49ca0f6c34ccd8bcbdd6f7f2a134f10412764b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e09535d77810cb646132bff31e99bdaac9ebfdb88868824a2f26f77594f4a34c"
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
