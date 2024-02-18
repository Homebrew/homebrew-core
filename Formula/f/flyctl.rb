class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.2.8",
      revision: "5f7df6e72efd968705e317983b76d5be73897a9a"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  # Upstream tags versions like `v0.1.92` and `v2023.9.8` but, as of writing,
  # they only create releases for the former and those are the versions we use
  # in this formula. We could omit the date-based versions using a regex but
  # this uses the `GithubLatest` strategy, as the upstream repository also
  # contains over a thousand tags (and growing).
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2a56e5618d6f9747127b3c02d1b5e6711f7d4553a476742ed5ad7227f81f2c8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a56e5618d6f9747127b3c02d1b5e6711f7d4553a476742ed5ad7227f81f2c8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a56e5618d6f9747127b3c02d1b5e6711f7d4553a476742ed5ad7227f81f2c8c"
    sha256 cellar: :any_skip_relocation, sonoma:         "dad3f109de44e5d0d01842aad7753e5e90e80a0aa1280210d8c71b27e1aff0c8"
    sha256 cellar: :any_skip_relocation, ventura:        "dad3f109de44e5d0d01842aad7753e5e90e80a0aa1280210d8c71b27e1aff0c8"
    sha256 cellar: :any_skip_relocation, monterey:       "dad3f109de44e5d0d01842aad7753e5e90e80a0aa1280210d8c71b27e1aff0c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c1526609a1e533dd3331a3658ea7e9cb45a9f86489cd319d492e0ccb0fed3e9"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.buildVersion=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "production"

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
