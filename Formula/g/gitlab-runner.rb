class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v18.8.0",
      revision: "9ffb4aa066204dc1b5f80b3043c30936002434fb"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06a176dd38d31b074b693e4b13bc31a6d48251b0c6d99b0434ac91f421e3a306"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06a176dd38d31b074b693e4b13bc31a6d48251b0c6d99b0434ac91f421e3a306"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06a176dd38d31b074b693e4b13bc31a6d48251b0c6d99b0434ac91f421e3a306"
    sha256 cellar: :any_skip_relocation, sonoma:        "9936bc1c20c7fb2e95e1eaa4924ba92bd1cb0fa2ef92e7db2d773cc65aa2f638"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4bb01b910323e646d814933ab52a7fe5cf113a9ec55e926450440891973e1c3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1c6619da0b79acf8231b0010acafd5b235209903f5b74eb1c74b39bef607a4e"
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
