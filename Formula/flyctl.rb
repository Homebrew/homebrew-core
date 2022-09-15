class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.391",
      revision: "53b6144b749f598bf68cf15e22941aafcd4499f9"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff32ade7b8876cc3762ca96706dc9569e5f67b6fd073d96389fff8ce498906f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff32ade7b8876cc3762ca96706dc9569e5f67b6fd073d96389fff8ce498906f7"
    sha256 cellar: :any_skip_relocation, monterey:       "42e9cd898c1b1875857295949ac2fc666cd49ad7eddf8b2fbc3b00d02a24854b"
    sha256 cellar: :any_skip_relocation, big_sur:        "42e9cd898c1b1875857295949ac2fc666cd49ad7eddf8b2fbc3b00d02a24854b"
    sha256 cellar: :any_skip_relocation, catalina:       "42e9cd898c1b1875857295949ac2fc666cd49ad7eddf8b2fbc3b00d02a24854b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb7463169e55220118904c86c0a8306dab0f786925ec4024cb10517f73382ee7"
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
