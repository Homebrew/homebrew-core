class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v15.6.0",
      revision: "b846829497b5fa1618d8270e687207356f795188"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d7ba93b47379e357e58ddeb7ceaa09e6689afecf8bb496adaee56bad53c7306"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12499794186199dbd1724499dfbe1c4a7d7eee6e08584c0d636ed0cca138af1c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71b722d97da087f9a4d891585411c7e959c659bd0e370f69eab75d168dc147f5"
    sha256 cellar: :any_skip_relocation, ventura:        "5011148cfe3bfd4dd51e0536ed8cf71a83180faceeb104b57b2e97f8322a1e13"
    sha256 cellar: :any_skip_relocation, monterey:       "6112af4bd5867d96d53d297572748f21db640624dffcf63e1932f79f67952c0c"
    sha256 cellar: :any_skip_relocation, big_sur:        "4bdf41e0ca9e855f7d66a6c868ea3e12a73b8af98d039f389900e6bbbc73fa36"
    sha256 cellar: :any_skip_relocation, catalina:       "e15f99ba45235284c7ff99bc2c64e73f7eb2dfa28d9232e1544825b88ebb5335"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ce85210f9894aa59eb08d52d40f89b267d37898905388660603d4c83d360bfb"
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
