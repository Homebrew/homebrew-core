class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.450",
      revision: "51325e4a2f23b4ff63662a0d84aeee1d7b79c6fc"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3066bc6f387217fca706d06b78e6e05e748e609d5133766ac12bd63613f77cad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3066bc6f387217fca706d06b78e6e05e748e609d5133766ac12bd63613f77cad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3066bc6f387217fca706d06b78e6e05e748e609d5133766ac12bd63613f77cad"
    sha256 cellar: :any_skip_relocation, ventura:        "6c7417b6aaebdca38eed34e39e4b94fc095df05eac0d992e206357a09c233ddc"
    sha256 cellar: :any_skip_relocation, monterey:       "6c7417b6aaebdca38eed34e39e4b94fc095df05eac0d992e206357a09c233ddc"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c7417b6aaebdca38eed34e39e4b94fc095df05eac0d992e206357a09c233ddc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1a1cd7a41b012f8a77aa5eb72e8138cf5da8965f09e9a795ce7f9ad07d59076"
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
