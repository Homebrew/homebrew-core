class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.475",
      revision: "a5acc104908d632d253d7f2757fcc7b06c14c5f2"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6bc6ff6796fdb6e13062e8bd3a77cb583db81b11d18858441f126863e308903a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6bc6ff6796fdb6e13062e8bd3a77cb583db81b11d18858441f126863e308903a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6bc6ff6796fdb6e13062e8bd3a77cb583db81b11d18858441f126863e308903a"
    sha256 cellar: :any_skip_relocation, ventura:        "8507b966de88b1bab9dcaf5d2e2219cc188359c0095da9c7d960978740e52359"
    sha256 cellar: :any_skip_relocation, monterey:       "8507b966de88b1bab9dcaf5d2e2219cc188359c0095da9c7d960978740e52359"
    sha256 cellar: :any_skip_relocation, big_sur:        "8507b966de88b1bab9dcaf5d2e2219cc188359c0095da9c7d960978740e52359"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "541487e9517803d0bd28e727ac9e9e9a48bef2b97199f97d489f9548a018dfd7"
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
