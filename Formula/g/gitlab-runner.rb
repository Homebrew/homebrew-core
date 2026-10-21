class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v19.5.0",
      revision: "70f5c12dad80bfd8ab426843f38cae72fddc4e75"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9ea53ce0fcb2752db710f6e817bcc064059a77ebb1959af75c5210ff10b5744c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "69d55fd7f9fb8fddbce95999a0683f629005f2dde6f586992981dc4470844f67"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "141c14c3335edc869eb30e6d24de4c57e3f6c8041657b9e91848d349c7cd4ee0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "07b930c9cdfb22dc2ea6f167de7bd8a4e12d757d5bb6dfc193a71a567460cd5a"
    sha256 cellar: :any,                 x86_64_linux:      "c789b1c67861515ee2c063582aef6725775060a2df6ca034dd0c533e47666385"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
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
