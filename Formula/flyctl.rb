class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.444",
      revision: "9abbcd53108cc1d6216626e4321c1b80e22d8892"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8d2c970c162477531efa19fc627397eb548614ba8b781b5bc72add75155b79f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8d2c970c162477531efa19fc627397eb548614ba8b781b5bc72add75155b79f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8d2c970c162477531efa19fc627397eb548614ba8b781b5bc72add75155b79f"
    sha256 cellar: :any_skip_relocation, ventura:        "960ce2e604837f109d1b7747224d5765e1f99f217c2d34c5105937dc3dda4413"
    sha256 cellar: :any_skip_relocation, monterey:       "960ce2e604837f109d1b7747224d5765e1f99f217c2d34c5105937dc3dda4413"
    sha256 cellar: :any_skip_relocation, big_sur:        "960ce2e604837f109d1b7747224d5765e1f99f217c2d34c5105937dc3dda4413"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a52d4c63acc1c7fd85328a6a08ef2a7aac63474ad3ecc7eb9ebeb49f86463f46"
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
