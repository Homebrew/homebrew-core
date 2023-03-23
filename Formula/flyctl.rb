class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.497",
      revision: "7362af3e38b05747b7facf41cb0cce3ee1c74578"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "917c7ba24e74380a6e0807b07c6f0bf95dc29ff04b121c002ea78faa24fe2366"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "917c7ba24e74380a6e0807b07c6f0bf95dc29ff04b121c002ea78faa24fe2366"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "917c7ba24e74380a6e0807b07c6f0bf95dc29ff04b121c002ea78faa24fe2366"
    sha256 cellar: :any_skip_relocation, ventura:        "24e5a0e9fc7cf29c50d41c65bc8150e328356d22dd07f82915f78f7454a1ff3c"
    sha256 cellar: :any_skip_relocation, monterey:       "24e5a0e9fc7cf29c50d41c65bc8150e328356d22dd07f82915f78f7454a1ff3c"
    sha256 cellar: :any_skip_relocation, big_sur:        "24e5a0e9fc7cf29c50d41c65bc8150e328356d22dd07f82915f78f7454a1ff3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd631d7e09727964adac37f9c460d5cb8ac0ad35d77888e6e01a783de9c86aa6"
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
