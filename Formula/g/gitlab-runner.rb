class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v19.5.3",
      revision: "33227fd48c5b411d0b49a74e129d187728abcc3b"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5bcdd4015de7ec82a96188c36569fcf04334573eca55de8e90db4e4fdb49d948"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "672747fa39192630bfb408680cc2687cfafe6561df89171799854b3ffd3c8a34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "26c25ffc5b3c04594347f3adcbf2932bd235f8369d4615a18a705d3810615bf4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "dfec68a8808227a28d6d57f6626205f92fea30e4fbde478fffba021ef63a0bab"
    sha256 cellar: :any,                 x86_64_linux:      "9086563b1327b93f56f2d86c20ea82a7847203e442f6f75e9ab8482ff12e6070"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    proj = "gitlab.com/gitlab-org/gitlab-runner"
    ldflags = %W[
      -X #{proj}/common.NAME=gitlab-runner
      -X #{proj}/common.VERSION=#{version}
      -X #{proj}/common.REVISION=#{Utils.git_short_head(length: 8)}
      -X #{proj}/common.BRANCH=#{version.major}-#{version.minor}-stable
      -X #{proj}/common.BUILT=#{time.strftime("%Y-%m-%dT%H:%M:%S%:z")}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  service do
    run [opt_bin/"gitlab-runner", "run", "--syslog"]
    environment_variables PATH: std_service_path_env
    working_dir Dir.home
    keep_alive true
    macos_legacy_timers true
    process_type :interactive
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitlab-runner --version")
  end
end
