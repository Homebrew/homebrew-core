class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v16.10.0",
      revision: "81ab07f6dd8cb2d577396a20d059fea7086e0d81"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "46316f4c7ff2523683feb202dbdcc5787d5376baf413c0da663cfbfb930ff264"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd66eccbbdac3ebe8dbc446bed2c9bc9a5681a7aadafd6eabaddc7ae67a39210"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "823c157fe9cc7fc4323f1994883db3a5dcd97dbccb862a3051e2901fde428120"
    sha256 cellar: :any_skip_relocation, sonoma:         "ab251411cbdba14b8f73ccafe59429080ee602412546f123082bc5dd36eca685"
    sha256 cellar: :any_skip_relocation, ventura:        "b5ba99b23bd7ccbf074da5aaab37c3a97917510d562b9c566faaf981669eab25"
    sha256 cellar: :any_skip_relocation, monterey:       "c74d78640823de0ba7ba749b3e5fef0ef967b4cd8a0e61b84450b91a569d38e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d487f033cf82ece33fad99978303713071a8d698e156414616c01dd14a56b52"
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
