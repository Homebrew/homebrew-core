class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v17.11.0",
      revision: "0f67ff190a5f069ef1e46f2a8950e1319e71d6e4"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc959e68dc955c1d535c03bf96338f9922967f89503d921b8f69c4f75f744c8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc959e68dc955c1d535c03bf96338f9922967f89503d921b8f69c4f75f744c8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bc959e68dc955c1d535c03bf96338f9922967f89503d921b8f69c4f75f744c8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "4097cb3f7413ddca292061f8bb007abca318e7f92795d32af40c15edb867e737"
    sha256 cellar: :any_skip_relocation, ventura:       "4097cb3f7413ddca292061f8bb007abca318e7f92795d32af40c15edb867e737"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d79fc6734824ab3a9d6bf4cb5733fedb02a6f70c53a669a0b5334fff75b91ac0"
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
