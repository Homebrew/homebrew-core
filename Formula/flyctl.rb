class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.541",
      revision: "7b4798af43e01a354916bc4cee63e0842851d68a"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "097d12bb890ce2d86031a9e27071228df565c47e319903e9f4e45e162d1fdf4f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "097d12bb890ce2d86031a9e27071228df565c47e319903e9f4e45e162d1fdf4f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "097d12bb890ce2d86031a9e27071228df565c47e319903e9f4e45e162d1fdf4f"
    sha256 cellar: :any_skip_relocation, ventura:        "027eff18fbbf0b8ca411223d3490517898dda0ee3dacb79a38e2e9a22ed1bbd6"
    sha256 cellar: :any_skip_relocation, monterey:       "027eff18fbbf0b8ca411223d3490517898dda0ee3dacb79a38e2e9a22ed1bbd6"
    sha256 cellar: :any_skip_relocation, big_sur:        "027eff18fbbf0b8ca411223d3490517898dda0ee3dacb79a38e2e9a22ed1bbd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11e405c21004f8f8d0af7fd055b9dd0177c7851c09d92e94071d2254903bcb1a"
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
