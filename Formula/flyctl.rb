class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.350",
      revision: "a54526046e8531fbc11d15c6dd95f83055f13b62"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b55b8632b019ef6301dddab25261b16fa95d02be224de294c06b1ad92b9157aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b55b8632b019ef6301dddab25261b16fa95d02be224de294c06b1ad92b9157aa"
    sha256 cellar: :any_skip_relocation, monterey:       "00271c892722bc78afd0defdbd4b98bd9df595a179b5ab1887559f126af6b895"
    sha256 cellar: :any_skip_relocation, big_sur:        "00271c892722bc78afd0defdbd4b98bd9df595a179b5ab1887559f126af6b895"
    sha256 cellar: :any_skip_relocation, catalina:       "00271c892722bc78afd0defdbd4b98bd9df595a179b5ab1887559f126af6b895"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44da44c9cc6b30dd5a38eb2b527581216d13d2c1858e97ede869f8a47367544f"
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
