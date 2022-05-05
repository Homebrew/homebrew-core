class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v14.10.1",
      revision: "f761588fb6cdd543ba702ba94c5ab5f102170117"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1da919da371cd72dcdee209ad2e2f2a1cda433b42f503ff8069f6dcf1ceaa6aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b0bf751f12dbd7e71c6dbfd0c46452cab1b55134c487826ab05772827e2fe77"
    sha256 cellar: :any_skip_relocation, monterey:       "16a3d41da7a9d2228d70c9e30256893b145a519a46f645c4126d988c195d8d34"
    sha256 cellar: :any_skip_relocation, big_sur:        "77b5083b44e79288ccd422e6bc278ec1445b01c8842ec35917888b18641bf06b"
    sha256 cellar: :any_skip_relocation, catalina:       "103479966455d2d49db7f9d275f04c9c053373cf546c1da5245078e1173e2a31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1304c5db8b94829f17366e00aa4c81fa9770782594bfed16f5e3f02854bf21d5"
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
