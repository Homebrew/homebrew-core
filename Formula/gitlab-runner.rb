class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v14.8.2",
      revision: "c6e7e19481b317ef189074f20426664037ab8e5c"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56074b4069046f9c8cb1ae886d4d9d9621fc2165d151e2400f98fb5005e4a933"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c1d0bf381fe6ce1b82ac2a3805ca157e6026e4d4bd62f93ff921bca76d1d5263"
    sha256 cellar: :any_skip_relocation, monterey:       "a7fc07e41bc2c92864b03d21ebac9e82a76fc163b9e0f1b7d7887d8b8f9f8e64"
    sha256 cellar: :any_skip_relocation, big_sur:        "5cce30599a5976245ba8e9c111fbf3ba3b5aab81fe7659667d500302d2a7db1f"
    sha256 cellar: :any_skip_relocation, catalina:       "e3c86f46e4b026d1ae1e93c808dd9fe25997dcc31414cf76ea0b4aa662d27fdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c16752e498080279cc5af529b5d9c33d4659bcdaffbc6b8c79113c2889d52609"
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
