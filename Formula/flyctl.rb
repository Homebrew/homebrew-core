class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.394",
      revision: "e5c99a224cb45b6b523556649766686a74b7c9c9"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "381529e947341a3885ea51ae3904b0b3dfe502a9b95ac8cd03ba7e7a9cf96055"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "381529e947341a3885ea51ae3904b0b3dfe502a9b95ac8cd03ba7e7a9cf96055"
    sha256 cellar: :any_skip_relocation, monterey:       "205bdda3cfe3b8e6793159cdd25c5919299acd24dddf58b1e8fb30b32f48de56"
    sha256 cellar: :any_skip_relocation, big_sur:        "205bdda3cfe3b8e6793159cdd25c5919299acd24dddf58b1e8fb30b32f48de56"
    sha256 cellar: :any_skip_relocation, catalina:       "205bdda3cfe3b8e6793159cdd25c5919299acd24dddf58b1e8fb30b32f48de56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e38e8b252cae246d424a7cb433de8c552b90432140deaa616b255c709ab847e7"
  end

  # Required latest gvisor.dev/gvisor/pkg/gohacks
  # Try to switch to the latest go on the next release
  depends_on "go@1.18" => :build

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
