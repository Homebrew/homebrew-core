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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6105f6eba593ea0cd7226bd7cc1a314db3354b93f21c3f4a0583d4ce962ddda0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebba1ab08a748ad83a99b77322d86d6d4164400d3d8991a37b570afbe11112fa"
    sha256 cellar: :any_skip_relocation, monterey:       "aed754e255e21e56bc4c83a2dc56ff66ad472881a7325948c74911a7d75238e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "77c0581327b05a41d1ed9d65d9804d6d7d731915b12b917f18b91bb9fbd025e8"
    sha256 cellar: :any_skip_relocation, catalina:       "98824a56d5b1a0017d53cc8e78039dfd5bcf62954ce0d661ae9cd6c42ee05bdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "523f495be3c260ec4b02a284be168210a4ef8a85fc73c69d047cf49849640cfa"
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
