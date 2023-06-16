class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.38",
      revision: "18aabcffe36cd5717404fb399320db721c486171"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58086c135e933a71dac685e3238782faeb235dccbecec23c237b76d98fae9fc5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58086c135e933a71dac685e3238782faeb235dccbecec23c237b76d98fae9fc5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "58086c135e933a71dac685e3238782faeb235dccbecec23c237b76d98fae9fc5"
    sha256 cellar: :any_skip_relocation, ventura:        "0675ec466e2ddfff1b6a9c6160bb9f4a84b3c161e1d49cc484fea107a14ed416"
    sha256 cellar: :any_skip_relocation, monterey:       "0675ec466e2ddfff1b6a9c6160bb9f4a84b3c161e1d49cc484fea107a14ed416"
    sha256 cellar: :any_skip_relocation, big_sur:        "0675ec466e2ddfff1b6a9c6160bb9f4a84b3c161e1d49cc484fea107a14ed416"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc92b3dbd2f7ecdb4c2b57e738e9571e7db6e6820eefc5692ea5f6f1b86a59cd"
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
