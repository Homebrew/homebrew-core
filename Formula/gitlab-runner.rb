class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v14.8.0",
      revision: "565b6c0b448b3bbc85118ec48d5b62a6370aa6d8"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b672057c4b597279acf6a3ef1dd1851327a39e09c10eed1219d594df36f3ff8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42664dce5b004d848fbca9c171196556d4330a95ec4a3efdef975d3502783dd6"
    sha256 cellar: :any_skip_relocation, monterey:       "f371a4bb54fb185d28f60c29fd23c10df4fc315a51f1ca88162c6de4a864363b"
    sha256 cellar: :any_skip_relocation, big_sur:        "40481e7481eb5d49f712172b13f78cae99c4259ffe5d4d1d2570ededb053f129"
    sha256 cellar: :any_skip_relocation, catalina:       "cd1bfea2d6d753e6223e9397d71723689bd2a9646ffbc68935582d5018b83cb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "944896f4dd8f5c91b5275068b1e6821f3fca8ff834cc1e9d2e4b67a41a31148b"
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
    working_dir ENV["HOME"]
    keep_alive true
    macos_legacy_timers true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitlab-runner --version")
  end
end
