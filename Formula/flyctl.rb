class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.494",
      revision: "fdc006911d0db83e137aeeb18b70b3c0db9cf938"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb5a7782b5a1660e4411e8c952f7bb2eb27f17b0f7ea3f8c53b0922c0e7e8115"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb5a7782b5a1660e4411e8c952f7bb2eb27f17b0f7ea3f8c53b0922c0e7e8115"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb5a7782b5a1660e4411e8c952f7bb2eb27f17b0f7ea3f8c53b0922c0e7e8115"
    sha256 cellar: :any_skip_relocation, ventura:        "944a1952ac0adbf4158a79befbd67f3e94f4a272ab6ca2adddca13f581ab36b3"
    sha256 cellar: :any_skip_relocation, monterey:       "944a1952ac0adbf4158a79befbd67f3e94f4a272ab6ca2adddca13f581ab36b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "944a1952ac0adbf4158a79befbd67f3e94f4a272ab6ca2adddca13f581ab36b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53ca3a7d66675343d85026f34a7dd3de074f09920cb8e0b2beb7c90980c56a81"
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
