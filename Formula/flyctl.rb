class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.478",
      revision: "b7b2ce9faffd23cbb64794835589dfccdec92d24"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "024f30b2ed229d41af78bd632721ad3d8c555dd9d80c14235a8df1431d80b93e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "024f30b2ed229d41af78bd632721ad3d8c555dd9d80c14235a8df1431d80b93e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "024f30b2ed229d41af78bd632721ad3d8c555dd9d80c14235a8df1431d80b93e"
    sha256 cellar: :any_skip_relocation, ventura:        "378d76d888f12b806105344ce641e280b31035aea205b17658cc780af9d30308"
    sha256 cellar: :any_skip_relocation, monterey:       "378d76d888f12b806105344ce641e280b31035aea205b17658cc780af9d30308"
    sha256 cellar: :any_skip_relocation, big_sur:        "378d76d888f12b806105344ce641e280b31035aea205b17658cc780af9d30308"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99a9549841dfbe727629b1735b878c9d869399e0770931e2f8e0187457016d78"
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
