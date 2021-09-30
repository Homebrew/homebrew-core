class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v14.3.1",
      revision: "8b63c432e32bdc71a8641afe783000698610e528"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2f9f33e15c531ce298f56170262771344c1912813d7ce26e382e2e68569d5911"
    sha256 cellar: :any_skip_relocation, big_sur:       "6263a5a383b2dfdfe5fc20b9948d6735ffa7ee4863bb45260947c4ad7acb7bd0"
    sha256 cellar: :any_skip_relocation, catalina:      "a100d4053e0f376ec7e8d140753f4765a700e52efcff3659613b6b7a315f6867"
    sha256 cellar: :any_skip_relocation, mojave:        "478ac62d70ca253a57adf56d905d61bcd1c06a75fd8e16bfc887bebce2610f30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75cbfd88fe2a25286707785d4d027812437b78404cb05f99c1a9863828cd529e"
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
