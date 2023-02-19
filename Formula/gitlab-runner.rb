class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v15.9.0",
      revision: "c20f0becbc8e79ca6bab0e18aac9f623dc4e5f71"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5922b4de1f1f1c34f9056a238ba68cc7a76c747c8e2c05739fe938d5d1c0868"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7808155ddf07376d02d988c38a03a35b10318ace1119d7a99401f71b7346d61e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c8db8482e17af9346b4559ffc28df58bdbe06b151dfc81a4ccf19d57cb5c029"
    sha256 cellar: :any_skip_relocation, ventura:        "e24ed7fa3afa0433db5495fd0571846cd80a0a7cde93a23cc3a069e048f7e17f"
    sha256 cellar: :any_skip_relocation, monterey:       "3383d197e3aa2c4e90ea3182d3884e324a6e8b55468d37b89ccf038a94e05809"
    sha256 cellar: :any_skip_relocation, big_sur:        "005656a2cb8fabed65de1473d5251827c33bbb8ceaf3c47baffe01f1ab982e0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "772dd496b4d88aad0fbf1ae74033e4197955ecc596bf5031edfbded217c575b0"
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
