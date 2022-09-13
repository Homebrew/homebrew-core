class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.390",
      revision: "94fec0925c75cfe30921f1a4df25fa9cbf2877e9"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d1196370db9452df29be743273cfd1d6bf77cca1930e3ae0b3f300552b260a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d1196370db9452df29be743273cfd1d6bf77cca1930e3ae0b3f300552b260a8"
    sha256 cellar: :any_skip_relocation, monterey:       "6e3e74c34da25e1d9f46fc5309bd513400f142c2e8e7bdc274bbf0591f8e8e25"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e3e74c34da25e1d9f46fc5309bd513400f142c2e8e7bdc274bbf0591f8e8e25"
    sha256 cellar: :any_skip_relocation, catalina:       "6e3e74c34da25e1d9f46fc5309bd513400f142c2e8e7bdc274bbf0591f8e8e25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb2a6177c3a3412367141102b9ad06c8c3714ba28649b7cdfd28856ebe0e50b2"
  end

  # Required latest gvisor.dev/gvisor/pkg/gohacks
  # Try to switch to the latest go on the next release
  depends_on "go@1.18" => :build

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
