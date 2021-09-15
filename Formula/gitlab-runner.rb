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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "70195e3ae326970935774b914259d738b1d86a9b11fda73f1556235b677e1a70"
    sha256 cellar: :any_skip_relocation, big_sur:       "449d726995abe7a83b560ce786c8d7e805913cd0548a54fd923fb6d4d6f8e257"
    sha256 cellar: :any_skip_relocation, catalina:      "284ed1c5f82d9b1b85db3f940e4d7c47e64f56b0bf2ad47f71e32c458bf0852b"
    sha256 cellar: :any_skip_relocation, mojave:        "385bdd2e6e02ab20a07d3134c3edd6cd4a9b5dc9a9d4e95673fc80c377985321"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c0aae97892d0fb4047713ba1b3f8b8dd348e120307a145a39878bee33aa4aed"
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
