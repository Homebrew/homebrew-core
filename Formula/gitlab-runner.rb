class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v16.1.0",
      revision: "b72e108d0133cce77b087058bbf2c7d2f7bf5480"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41efb4ab3ae339031e3e63629f77e8e5be6507b24cd8e5a0ba07f58d8f7d191c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41efb4ab3ae339031e3e63629f77e8e5be6507b24cd8e5a0ba07f58d8f7d191c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41efb4ab3ae339031e3e63629f77e8e5be6507b24cd8e5a0ba07f58d8f7d191c"
    sha256 cellar: :any_skip_relocation, ventura:        "d17838e19e0183b1c8edc08b7d12efca50617523eb73d80ae4eec3235ee0e45d"
    sha256 cellar: :any_skip_relocation, monterey:       "d17838e19e0183b1c8edc08b7d12efca50617523eb73d80ae4eec3235ee0e45d"
    sha256 cellar: :any_skip_relocation, big_sur:        "d17838e19e0183b1c8edc08b7d12efca50617523eb73d80ae4eec3235ee0e45d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55ee38ef5f46d49c763207741b6ffa01da849e79b1457b9ed6786dc92eae765c"
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
