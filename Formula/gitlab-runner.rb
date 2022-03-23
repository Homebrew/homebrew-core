class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v14.9.1",
      revision: "bd40e3da0ba8b9632f8e8d73c2fbff447ab037b3"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9d0c68325966520de9485d07c9549a236f9bd5a80c1087f911b305d44b311fd8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3e948a1d62ca3502575cdea2c7577b0fb5e07ad1f1d8e83ca80380b71d10d26"
    sha256 cellar: :any_skip_relocation, monterey:       "eac49b2f076eeeb17c74af7c6bbaf15469a5133db04e6beea6390c97cd189b6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "37702efc42cf09900c0297586b0f392bf418ff07232fa311e82732b8d708b0bd"
    sha256 cellar: :any_skip_relocation, catalina:       "35919030e9553dbc62ab7f44e53f38ad73fb9b97dfdad804bd44fd80a8ba0656"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf559f0674f998f16f59cec102372f2a386311f93cdac53fe95c328e44b5ff40"
  end

  # Bump to 1.18 when x/sys is updated (likely 14.9).
  depends_on "go@1.17" => :build

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
    process_type :interactive
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitlab-runner --version")
  end
end
