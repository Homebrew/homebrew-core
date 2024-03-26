class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.2.25",
      revision: "358c5fcbcbf3b9edfab38ba8f5e305c8b786231e"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "24b85e2dd8526a650cde364c8544fa97f466dd6e936135ec308d451b36c9f558"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24b85e2dd8526a650cde364c8544fa97f466dd6e936135ec308d451b36c9f558"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24b85e2dd8526a650cde364c8544fa97f466dd6e936135ec308d451b36c9f558"
    sha256 cellar: :any_skip_relocation, sonoma:         "1ed8eb2c4d2953e46a9a2541d57484359a67a078c963a7dd120a78c53439efa7"
    sha256 cellar: :any_skip_relocation, ventura:        "1ed8eb2c4d2953e46a9a2541d57484359a67a078c963a7dd120a78c53439efa7"
    sha256 cellar: :any_skip_relocation, monterey:       "1ed8eb2c4d2953e46a9a2541d57484359a67a078c963a7dd120a78c53439efa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e497a50012ab6622ad0442b6784a3b899db2e3aee5798652cd70ba2e18a53293"
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
