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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b136e081d906b25873e5288bfa822817f292d7c5bdf490e75dabaa5e316a9401"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d55714e1e13caf829706f197d109a5b39ec34af41c6f8230b49b1bb95c814d0"
    sha256 cellar: :any_skip_relocation, monterey:       "03798f980db0b4933e6f8d32e0aa80858be5ee250a28ab6de43e672a2244309b"
    sha256 cellar: :any_skip_relocation, big_sur:        "1c97ca1ba0b95c1cfc812d930b638ad2e6cbe9cfd500915468a39266a3992e1c"
    sha256 cellar: :any_skip_relocation, catalina:       "cbb1a58b81a0e30287491b9bd9102b95d1724ed0c974cd84a37e9dca3c93a3c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a4fde9e8854a5b29816ac6f208aa35ad724faaeb2101e9486a2ca3169db0825"
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
