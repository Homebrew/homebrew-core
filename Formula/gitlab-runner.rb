class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v14.3.2",
      revision: "e0218c922515f65159ec5569fd9a1de7040e1646"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f23ba0ea62f49c9f93ec2881837955ca52a8aaf9cb8e7897ca38715a76a754e4"
    sha256 cellar: :any_skip_relocation, big_sur:       "d3f75a4e9d61b9451b1813be0d74ab943ef2ac829eeef0fafb02068455fd43bc"
    sha256 cellar: :any_skip_relocation, catalina:      "5b8db7df68728bd7e13310d8eb77ab75766519d7e3d001c21fc4c2cdd0f62fb1"
    sha256 cellar: :any_skip_relocation, mojave:        "927546c4075cb8329beef754a90afe8d01cf422e3d58dad072c28f3cbd8e53d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a721f192fd1606f7c8666cc25d456bfeef02c79b7ed6323be4e62d2ab33c9bf8"
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
