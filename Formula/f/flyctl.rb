class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.106",
      revision: "094fed733858a6fb3f75bfca18b4b4780f70b229"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2b74e44623496d80464eb9a3a74f7889b5ca59a53464e697894abe8acc088f9f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b74e44623496d80464eb9a3a74f7889b5ca59a53464e697894abe8acc088f9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b74e44623496d80464eb9a3a74f7889b5ca59a53464e697894abe8acc088f9f"
    sha256 cellar: :any_skip_relocation, sonoma:         "ea15a58926f8fa36cadd185d1ab4ec2af326186c5b9d958c810b2805b5141dce"
    sha256 cellar: :any_skip_relocation, ventura:        "ea15a58926f8fa36cadd185d1ab4ec2af326186c5b9d958c810b2805b5141dce"
    sha256 cellar: :any_skip_relocation, monterey:       "ea15a58926f8fa36cadd185d1ab4ec2af326186c5b9d958c810b2805b5141dce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bf7e0ce4b31c685dcb68103565ac53861b5c26102f7e409313e6acde983b6a6"
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
