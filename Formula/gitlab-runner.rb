class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v15.10.0",
      revision: "456e34824406b57e26b4dec29e9038edc2ac0396"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "45b07a68436c9328f24758bd53b7c18993f310ff29a7d0f519a5f1079d507b41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1d45c51be0050cf4b4daaa6bbd9bcadf734e718a3a2766276961ef94e9b3d91"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1d45c51be0050cf4b4daaa6bbd9bcadf734e718a3a2766276961ef94e9b3d91"
    sha256 cellar: :any_skip_relocation, ventura:        "475d91b746f7a7a76c25f5b52737584e8417224e401366852cc5353cba763eb7"
    sha256 cellar: :any_skip_relocation, monterey:       "475d91b746f7a7a76c25f5b52737584e8417224e401366852cc5353cba763eb7"
    sha256 cellar: :any_skip_relocation, big_sur:        "475d91b746f7a7a76c25f5b52737584e8417224e401366852cc5353cba763eb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bed360310f21256330df4b475f2287f6043c483997ffa2a9b15ab4e3a1af2d57"
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
