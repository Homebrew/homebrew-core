class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.508",
      revision: "c44008d3d008e20d32967c396809f6b1a85c764f"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7706cc3572a834ce27b3522104ec143b19b6e5c7a82ebafe8ceaf36212f6833"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7706cc3572a834ce27b3522104ec143b19b6e5c7a82ebafe8ceaf36212f6833"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e7706cc3572a834ce27b3522104ec143b19b6e5c7a82ebafe8ceaf36212f6833"
    sha256 cellar: :any_skip_relocation, ventura:        "c08a3be1b667c72096da3014729019e70f70fb5b718e0735618a97fb067293ed"
    sha256 cellar: :any_skip_relocation, monterey:       "c08a3be1b667c72096da3014729019e70f70fb5b718e0735618a97fb067293ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "c08a3be1b667c72096da3014729019e70f70fb5b718e0735618a97fb067293ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64c3debfe8fcb09815f682c9702bd91b38690cd07da476d4b8cd4842bf84de73"
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
