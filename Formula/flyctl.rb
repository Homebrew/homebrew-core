class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.446",
      revision: "352bd3e3896b83d039caec470d71528817063521"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a4e4ae49dcb955dbec9107bacfc0beeb2a544e2f0881799c2bf7c4eac829b8e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a4e4ae49dcb955dbec9107bacfc0beeb2a544e2f0881799c2bf7c4eac829b8e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a4e4ae49dcb955dbec9107bacfc0beeb2a544e2f0881799c2bf7c4eac829b8e"
    sha256 cellar: :any_skip_relocation, ventura:        "af09b6f300d4c2fda1abc29f8dc5309bea4dc8c4ef0fb5182ba6b758c96a2258"
    sha256 cellar: :any_skip_relocation, monterey:       "af09b6f300d4c2fda1abc29f8dc5309bea4dc8c4ef0fb5182ba6b758c96a2258"
    sha256 cellar: :any_skip_relocation, big_sur:        "af09b6f300d4c2fda1abc29f8dc5309bea4dc8c4ef0fb5182ba6b758c96a2258"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f9d196118015481d69de6fec4a9b8809562be55e5ffbce97ceda6881ff6d0f1"
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
