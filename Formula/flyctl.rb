class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.333",
      revision: "473cbaf1e347df70892f45c4d544e657877063c5"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "670fb1c5bf6b1db3890b6170641311019aeb1c522bebe7759b7b013c744e2393"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "670fb1c5bf6b1db3890b6170641311019aeb1c522bebe7759b7b013c744e2393"
    sha256 cellar: :any_skip_relocation, monterey:       "1517b5aec0556c83b9286e2e4d31d1e1d144e5029a23f39c2a6201a6a2e69871"
    sha256 cellar: :any_skip_relocation, big_sur:        "1517b5aec0556c83b9286e2e4d31d1e1d144e5029a23f39c2a6201a6a2e69871"
    sha256 cellar: :any_skip_relocation, catalina:       "1517b5aec0556c83b9286e2e4d31d1e1d144e5029a23f39c2a6201a6a2e69871"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "517107fb10aefc794a24e11b978ca77d681bfa34a1893b6be1c65c36a1240846"
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
