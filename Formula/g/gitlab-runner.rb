class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v18.4.0",
      revision: "139a0ac033907890894642625cdfabf215c614fd"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9eeb97d3550ecd2d0973ad148155994c16f99a3bbef79c78a37ac5855c1de1e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9eeb97d3550ecd2d0973ad148155994c16f99a3bbef79c78a37ac5855c1de1e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9eeb97d3550ecd2d0973ad148155994c16f99a3bbef79c78a37ac5855c1de1e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "65c12f8de0671218b23ad45698b4365fcf51636a63c27e283b8ded5950fee4d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1afc787c0812067f4b8b3892a8d8fb06dd4a5ef35f143183b435d8b266df56f"
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
