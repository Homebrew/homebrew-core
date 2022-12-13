class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.438",
      revision: "7fe25da4e2b96a4df463b1a1edf2fce7bbcc42f7"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c9f068645a5a1de0c192fb8aa2396c60a97406a024146d5895bfb4d8881f805"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c9f068645a5a1de0c192fb8aa2396c60a97406a024146d5895bfb4d8881f805"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c9f068645a5a1de0c192fb8aa2396c60a97406a024146d5895bfb4d8881f805"
    sha256 cellar: :any_skip_relocation, ventura:        "b0510ddcebe123ff46f9c0733306e4d494f833285b046cd7980fcdcea62721fb"
    sha256 cellar: :any_skip_relocation, monterey:       "b0510ddcebe123ff46f9c0733306e4d494f833285b046cd7980fcdcea62721fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0510ddcebe123ff46f9c0733306e4d494f833285b046cd7980fcdcea62721fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40ab8fdd6cbd04ca20d952012254df5625f21e81039695a77dacfad4e6c073bf"
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
