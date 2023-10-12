class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.107",
      revision: "31d06138257c50b77db4b45b3a38e81869d0dfc7"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0eb97d690dc66c862b0e253bf8c2744e4a3d7a1da7288da067ba4358838d4d0b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0eb97d690dc66c862b0e253bf8c2744e4a3d7a1da7288da067ba4358838d4d0b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0eb97d690dc66c862b0e253bf8c2744e4a3d7a1da7288da067ba4358838d4d0b"
    sha256 cellar: :any_skip_relocation, sonoma:         "a944d9a7c634b5a4b9398f14fef624c9a2bfa87e73a12260ef4c16a33a23eb43"
    sha256 cellar: :any_skip_relocation, ventura:        "a944d9a7c634b5a4b9398f14fef624c9a2bfa87e73a12260ef4c16a33a23eb43"
    sha256 cellar: :any_skip_relocation, monterey:       "a944d9a7c634b5a4b9398f14fef624c9a2bfa87e73a12260ef4c16a33a23eb43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4dbd454cea6459aa982c4cbe289540e3b6f0dcf9df5f6b181a94217fa6ada061"
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
