class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v18.6.0",
      revision: "3a847532c33b6fe2a331a651a6f53be1b2ebed79"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0fea3ab2b80748ea0d206096affcc66537adaa4adb1bd31d705f2aaa6cd47966"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fea3ab2b80748ea0d206096affcc66537adaa4adb1bd31d705f2aaa6cd47966"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0fea3ab2b80748ea0d206096affcc66537adaa4adb1bd31d705f2aaa6cd47966"
    sha256 cellar: :any_skip_relocation, sonoma:        "17ab86b09f9d72e9c3875981a37e16735f26167d92763ede3f035ea40851d932"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ce740a18b6953a99307bbd062328cfdc8a2719a965480f0d24864a7eeb8a508"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95db79d67aa84e86c370cda1634465d85dd792109225d90b963df912b578e76a"
  end

  depends_on "go" => :build

  def install
    proj = "gitlab.com/gitlab-org/gitlab-runner"
    ldflags = %W[
      -s -w
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
