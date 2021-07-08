class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v14.0.1",
      revision: "c1edb47838c7a0862e0bea80622f98798f34fd4e"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "191d0e22a3a4bbdd8400413c2adcce6dfbf088706b40f804cca2738580eb8c7c"
    sha256 cellar: :any_skip_relocation, big_sur:       "c8e1a75b4ba9a6353055866fae3cc0e17898f49b185d1b8094c6dfb4a90a9080"
    sha256 cellar: :any_skip_relocation, catalina:      "25fd3bfb505971967d2f807b4e54c81319397781f48563ffa119db3c83a0f8a8"
    sha256 cellar: :any_skip_relocation, mojave:        "d0659d95203d06f63f578b5ba6101628d2fe208890cb5123f817fc55f0ce048a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b2c7c5be75ff20957af40537ea8af77f01676558d5aa1a1fea29df5324ad419"
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
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  service do
    run [opt_bin/"gitlab-runner", "run", "--syslog"]
    environment_variables PATH: std_service_path_env
    working_dir ENV["HOME"]
    keep_alive true
    macos_legacy_timers true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitlab-runner --version")
  end
end
