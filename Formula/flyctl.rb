class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.309",
      revision: "7f90ae39733a7f85ea79b5607f4716596c7316ee"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "452f74303fe9809e50ae0adc65296cf2e618197c326d78145235ecdbf0bdd5ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "452f74303fe9809e50ae0adc65296cf2e618197c326d78145235ecdbf0bdd5ad"
    sha256 cellar: :any_skip_relocation, monterey:       "b87d0cbb40fd658e36b6c1da187787c4fbc4fa8c2c4236dbf9752253cb75ebf7"
    sha256 cellar: :any_skip_relocation, big_sur:        "b87d0cbb40fd658e36b6c1da187787c4fbc4fa8c2c4236dbf9752253cb75ebf7"
    sha256 cellar: :any_skip_relocation, catalina:       "b87d0cbb40fd658e36b6c1da187787c4fbc4fa8c2c4236dbf9752253cb75ebf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9112878cc2a07cbe05137906f1aa18ce7abceebd464fd74956dfcd9288e2404"
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
