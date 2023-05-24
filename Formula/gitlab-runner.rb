class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v16.0.1",
      revision: "79704081c9fe038e6054066d7d7462c712d7345e"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d99f42172281c567120800991969e823ab3229891c88f5069445ceed2fe474a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d99f42172281c567120800991969e823ab3229891c88f5069445ceed2fe474a1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d99f42172281c567120800991969e823ab3229891c88f5069445ceed2fe474a1"
    sha256 cellar: :any_skip_relocation, ventura:        "b9d74da1cdbffb78f7341147c2e204ddf6965967511d6a7b2c64d548abaf4824"
    sha256 cellar: :any_skip_relocation, monterey:       "b9d74da1cdbffb78f7341147c2e204ddf6965967511d6a7b2c64d548abaf4824"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9d74da1cdbffb78f7341147c2e204ddf6965967511d6a7b2c64d548abaf4824"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6e6b19e0ec7c6966999d43a6ec991dad20754c4207c3585daf05954874f387b"
  end

  depends_on "go" => :build

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
