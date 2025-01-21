class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v17.8.1",
      revision: "a1fca00efa515c8af7ed175e09c112b2c21a9754"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4efe2e42e55279a41ab34dfbcb800244f0679db15df8a85079e05786106e007a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4efe2e42e55279a41ab34dfbcb800244f0679db15df8a85079e05786106e007a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4efe2e42e55279a41ab34dfbcb800244f0679db15df8a85079e05786106e007a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d282552e3b5a4edd91be37bda2c33d830cc9b28800777ea465f17ffdc088b479"
    sha256 cellar: :any_skip_relocation, ventura:       "d282552e3b5a4edd91be37bda2c33d830cc9b28800777ea465f17ffdc088b479"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8745fd8b124cc918adf5240df1fca2fbd3bf2a22cb1bb52766c732659752df4"
  end

  depends_on "go" => :build

  def install
    proj = "gitlab.com/gitlab-org/gitlab-runner"
    ldflags = %W[
      -s -w
      -X #{proj}/common.NAME=gitlab-runner
      -X #{proj}/common.VERSION=#{version}
      -X #{proj}/common.REVISION=#{Utils.git_short_head(length: 8)}
      -X #{proj}/common.BRANCH=#{version.major}-#{version.minor}-stable
      -X #{proj}/common.BUILT=#{time.strftime("%Y-%m-%dT%H:%M:%S%:z")}
      -B gobuildid
    ]
    system "go", "build", *std_go_args(ldflags:)
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
