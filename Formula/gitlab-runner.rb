class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v15.2.1",
      revision: "32fc1585e5334b1a4c4fd4962a7679fcebaf8f49"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dce78aaa2fb1e56618f24c05cd30f8ab3fc9eea916309e6d01ac6d6d930583d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9bebaf16a398aedda69b7f4f1a8826715f736880ef6c8b759668ecca015fdab"
    sha256 cellar: :any_skip_relocation, monterey:       "f6d2bd828cd5bf144236ab4a191a7809b0a2e63ca4d0347a58fbde48c846a96f"
    sha256 cellar: :any_skip_relocation, big_sur:        "2aea916d3cdd655893113c7c564b18e2634252eaeb9644ec6aab19a675f45583"
    sha256 cellar: :any_skip_relocation, catalina:       "da59e15974908fcf3d5217b41d3507bad395c8360a15d213fefd216513abb3c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8b7a58206ba527cf5a61e2f8a33536f55e31c7b626f4e4312fe4bb86ef6f964"
  end

  # Bump to 1.18 when x/sys is updated (likely 14.9).
  depends_on "go@1.17" => :build

  def install
    proj = "gitlab.com/gitlab-org/gitlab-runner"
    ldflags = %W[
      -X #{proj}/common.NAME=gitlab-runner
      -X #{proj}/common.VERSION=#{version}
      -X #{proj}/common.REVISION=#{Utils.git_short_head(length: 8)}
      -X #{proj}/common.BRANCH=#{version.major}-#{version.minor}-stable
      -X #{proj}/common.BUILT=#{time.strftime("%Y-%m-%dT%H:%M:%S%:z")}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
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
