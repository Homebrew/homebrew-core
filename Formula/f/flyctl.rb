class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.2.45",
      revision: "cf1ef68cacf7105b3d497e86c52d91e907e68a6d"
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
    throttle 5
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f7078128365ee184ae87432c58e5e5bd5e43b53db52a6497a662634345b70724"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7078128365ee184ae87432c58e5e5bd5e43b53db52a6497a662634345b70724"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7078128365ee184ae87432c58e5e5bd5e43b53db52a6497a662634345b70724"
    sha256 cellar: :any_skip_relocation, sonoma:         "a4822a374d77bd62e4690d48ac1e01e7bd8adef4448278b523541fa0f02872ca"
    sha256 cellar: :any_skip_relocation, ventura:        "a4822a374d77bd62e4690d48ac1e01e7bd8adef4448278b523541fa0f02872ca"
    sha256 cellar: :any_skip_relocation, monterey:       "a4822a374d77bd62e4690d48ac1e01e7bd8adef4448278b523541fa0f02872ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bae6f00df21b6d29789675f21a77e36557bcc11cafa6c7bea81f4b834029822"
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
    system "go", "build", *std_go_args(ldflags:), "-tags", "production"

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
