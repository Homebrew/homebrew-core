class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.428",
      revision: "1d88f5128538312c7b6d34e2437e17ed05fc1042"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "555c8e9ce6e2dec7317bd5810abfbff80ae4cd6a66dd97f0fd5b23eabfd5bcc3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "555c8e9ce6e2dec7317bd5810abfbff80ae4cd6a66dd97f0fd5b23eabfd5bcc3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "555c8e9ce6e2dec7317bd5810abfbff80ae4cd6a66dd97f0fd5b23eabfd5bcc3"
    sha256 cellar: :any_skip_relocation, monterey:       "708fe4a810db7465e52e93dcaf9d08534c0eac4c707292dc131102ea8e919a37"
    sha256 cellar: :any_skip_relocation, big_sur:        "708fe4a810db7465e52e93dcaf9d08534c0eac4c707292dc131102ea8e919a37"
    sha256 cellar: :any_skip_relocation, catalina:       "708fe4a810db7465e52e93dcaf9d08534c0eac4c707292dc131102ea8e919a37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04fa609c39f74e8ff728f0553e771b5b2a93e454cfa91aa26ed53aebfa0a2e8b"
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
