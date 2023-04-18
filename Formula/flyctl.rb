class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.525",
      revision: "01be82d654103586d6363b276d268cfca5946e60"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43633e8176cbfa77d0081a7a5a18000a3c911fed5c40d26410cb290ee83e7e18"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "43633e8176cbfa77d0081a7a5a18000a3c911fed5c40d26410cb290ee83e7e18"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43633e8176cbfa77d0081a7a5a18000a3c911fed5c40d26410cb290ee83e7e18"
    sha256 cellar: :any_skip_relocation, ventura:        "bf90d63bc0d9d9ef879e224fbddcd346599d392974ce01c56f94c40a691d544e"
    sha256 cellar: :any_skip_relocation, monterey:       "bf90d63bc0d9d9ef879e224fbddcd346599d392974ce01c56f94c40a691d544e"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf90d63bc0d9d9ef879e224fbddcd346599d392974ce01c56f94c40a691d544e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a202bb837dceaef5b61a1db3ebe7e41a55a870cf766faa375796772891339644"
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
