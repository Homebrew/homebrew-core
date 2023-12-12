class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v16.6.1",
      revision: "f5da3c5adf55e55004e0dae2a2e1476f8407c087"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "61f7286c4aa42b2bad12b393cb8be996ae289e0d26dddeff6d007d92622cd9f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa11c3208238c4d54eb4544f679f3cc1ca2e5d243091b9bb93314cf47d4b7fab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4ade14ec8ab073f6151025d67e1965636ffca3c053670f04d719266ccbee7995"
    sha256 cellar: :any_skip_relocation, sonoma:         "119564a973b88b7249e7540e8d7fe27d88b5213348c5a52583103529f70d63df"
    sha256 cellar: :any_skip_relocation, ventura:        "36061fca820e1e492cc94fbd87c415e48b74d9f8dfaacabc8f2acb2de54dcf00"
    sha256 cellar: :any_skip_relocation, monterey:       "710bbecb79bb6102ad981589753913bddefc3ae7e4a0352aa3e107ceb8ba3a9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28da3e89523b0554ac11f2b16f281aa47a35b1a996e3db53844e056fee8d88a2"
  end

  depends_on "go" => :build

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
    working_dir Dir.home
    keep_alive true
    macos_legacy_timers true
    process_type :interactive
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitlab-runner --version")
  end
end
