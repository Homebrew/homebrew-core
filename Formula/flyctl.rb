class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.495",
      revision: "b1f95f15eccd689acc11c57421c2337fee476540"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3cbec04bf81db522f78bf6debadf81a920c2f1979d4585f7ec83487152eaf41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3cbec04bf81db522f78bf6debadf81a920c2f1979d4585f7ec83487152eaf41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3cbec04bf81db522f78bf6debadf81a920c2f1979d4585f7ec83487152eaf41"
    sha256 cellar: :any_skip_relocation, ventura:        "574082accb02c03fd7238a8d87517514f27559db88dee5ad124bf7d0be70741a"
    sha256 cellar: :any_skip_relocation, monterey:       "574082accb02c03fd7238a8d87517514f27559db88dee5ad124bf7d0be70741a"
    sha256 cellar: :any_skip_relocation, big_sur:        "574082accb02c03fd7238a8d87517514f27559db88dee5ad124bf7d0be70741a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd5c0f3960e7adbc77d29d51122e6186d8ddd47aeac9b666213babb77d5a9c79"
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
