class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v17.11.1",
      revision: "96856197176687bb5744a7562cc65130b32d4005"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "691901069451cfe11239216cd4694eb10a8e85e9869adf74e9cc588811c10364"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "691901069451cfe11239216cd4694eb10a8e85e9869adf74e9cc588811c10364"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "691901069451cfe11239216cd4694eb10a8e85e9869adf74e9cc588811c10364"
    sha256 cellar: :any_skip_relocation, sonoma:        "df07cbcaaa897c54746046c39c008765ec005a286f48e6cb50227f1424817bee"
    sha256 cellar: :any_skip_relocation, ventura:       "df07cbcaaa897c54746046c39c008765ec005a286f48e6cb50227f1424817bee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce6f07c34b0266263b2b3197c77a47700e469a591ec6ec68e143c00dd4cb35a5"
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
