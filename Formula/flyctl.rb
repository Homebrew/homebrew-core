class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.413",
      revision: "e9a14678c7381b516a2757b00144b622356cdcdd"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec3069be35d8e140fbacd777b2db07ddb66c47f6939a80865bd96f660e971914"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec3069be35d8e140fbacd777b2db07ddb66c47f6939a80865bd96f660e971914"
    sha256 cellar: :any_skip_relocation, monterey:       "0f4ac3a908b7df54e1aa12de6b29b62e5a8cca7f36e62197c6ebe09c1a99bb30"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f4ac3a908b7df54e1aa12de6b29b62e5a8cca7f36e62197c6ebe09c1a99bb30"
    sha256 cellar: :any_skip_relocation, catalina:       "0f4ac3a908b7df54e1aa12de6b29b62e5a8cca7f36e62197c6ebe09c1a99bb30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a80df455b0bff491a748f051b5127d640e847c04f9d9d88fdd406d14b5aabe7e"
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
