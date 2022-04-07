class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.315",
      revision: "e4a3a010da5aa286c492ba9f27b3414a542eab2b"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39aab8b774f987ed2265247835e3a6b593f40e896395e5cfcdc1e0a134fdcc1c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39aab8b774f987ed2265247835e3a6b593f40e896395e5cfcdc1e0a134fdcc1c"
    sha256 cellar: :any_skip_relocation, monterey:       "3a69f2bbef56edc969d3a09c82090b95037e16e5945ab3a5cfc53da3300b6477"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a69f2bbef56edc969d3a09c82090b95037e16e5945ab3a5cfc53da3300b6477"
    sha256 cellar: :any_skip_relocation, catalina:       "3a69f2bbef56edc969d3a09c82090b95037e16e5945ab3a5cfc53da3300b6477"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b8f370165bb70490309e0efdb3f66e038ff804c7199324ded88d6adc51c9764"
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

    bash_output = Utils.safe_popen_read("#{bin}/flyctl", "completion", "bash")
    (bash_completion/"flyctl").write bash_output
    zsh_output = Utils.safe_popen_read("#{bin}/flyctl", "completion", "zsh")
    (zsh_completion/"_flyctl").write zsh_output
    fish_output = Utils.safe_popen_read("#{bin}/flyctl", "completion", "fish")
    (fish_completion/"flyctl.fish").write fish_output
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("flyctl status 2>&1", 1)
    assert_match "Error No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
