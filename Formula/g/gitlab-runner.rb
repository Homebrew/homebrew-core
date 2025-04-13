class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v17.10.1",
      revision: "ef334dcc399bbda2930ef1f83197718e25053392"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4be496e11d4c4bf0305e2b5ec42c1860fba5d83ee37ca9aa00da8f1e47d0a8f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4be496e11d4c4bf0305e2b5ec42c1860fba5d83ee37ca9aa00da8f1e47d0a8f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4be496e11d4c4bf0305e2b5ec42c1860fba5d83ee37ca9aa00da8f1e47d0a8f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "8eefdcc2fe176c3d2290aac339bca25cfe66251796b1cd018e3e7fb335dcdfc8"
    sha256 cellar: :any_skip_relocation, ventura:       "8eefdcc2fe176c3d2290aac339bca25cfe66251796b1cd018e3e7fb335dcdfc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6da88a0a319f1802a7e631dc15dfb975e72228b456ae6810f5a51e79cbc8c9d0"
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
