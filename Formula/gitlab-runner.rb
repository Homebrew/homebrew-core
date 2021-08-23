class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v14.2.0",
      revision: "58ba2b95c1808bc61882b60639371934c2c8d9c4"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4017374ee8ebe818985995a346c66ec7438416573dbae4d326a7d80bbe367cd8"
    sha256 cellar: :any_skip_relocation, big_sur:       "5bdfe0e955e2761c47a8016be92dbe35af60a8e10febe76996aec02bcc736e8c"
    sha256 cellar: :any_skip_relocation, catalina:      "f1097a08020404d4ef163e4b68f3de99f647eb83b198099776966948740cbfb2"
    sha256 cellar: :any_skip_relocation, mojave:        "4cd4d95737a3eaf45ffec086f307428d7338fe2d2c9f61007f93bc065f18a0f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd24acfe88f1e806270490d5f62928941a1599b8e7e74c9691c5705d72670cd5"
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
