class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v14.6.0",
      revision: "5316d4acc957286b43fe29e64684af694de6841d"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de1fee47a8aa164ba1df51314e958c499915696d3189c040906a68f6cf8e4818"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0be358ab45d037978a6fe37123c32384a58233df796b787a2ebe4f07ef6eace"
    sha256 cellar: :any_skip_relocation, monterey:       "e06941db0f74abed1028cdcf074fca27b7100c6f8b97f211f05cdbb33b0dfd8d"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f437dc2d44bfcea7d5196b1c28cf9a835ec73c166a8e596cb46517e8afd359c"
    sha256 cellar: :any_skip_relocation, catalina:       "83b5dbb802de2bd62e89ab4b920e66783534534c60fd4a4bb094961a8c7787c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b99220dcb2591ecc4a3fd769d9de84363438691260f06c3e4c2c6c40b296989"
  end

  depends_on "go" => :build

  # Remove patch for Go FD=0 bug (CVE-2021-44717), as go is already patched against this CVE.
  # Remove during v14.7.0 update.
  patch do
    url "https://gitlab.com/gitlab-org/gitlab-runner/-/commit/99f7b8063024357389f07f1e977d280ec35195e1.diff"
    sha256 "115eb6f9c02eaa05fea945d76a42ef5585cac7c5ee9938cab0183330401506a6"
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
