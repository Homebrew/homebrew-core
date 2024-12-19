class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v17.7.0",
      revision: "3153ccc6dafba6dd4aef53cd2261ebcc996f5caa"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d40bed39d611f0d500832efcb185c4edeb427cf572ba6c75dc8cfc5714cc610"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0d40bed39d611f0d500832efcb185c4edeb427cf572ba6c75dc8cfc5714cc610"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d40bed39d611f0d500832efcb185c4edeb427cf572ba6c75dc8cfc5714cc610"
    sha256 cellar: :any_skip_relocation, sonoma:        "593c297e069f9469027cfbecc0343aeca6a6ec9937dc48e6368150f2c98b750b"
    sha256 cellar: :any_skip_relocation, ventura:       "593c297e069f9469027cfbecc0343aeca6a6ec9937dc48e6368150f2c98b750b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b4f3b3bf9eb7817e182141d3819a2591c01de1458032b1490f0eaeafad4a6f6"
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
