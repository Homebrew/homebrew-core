class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v15.1.0",
      revision: "76984217c7ef0bf669da0eb0d6337a54ba1ff14a"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29e742eddcdd1692ec3bc8ca847210bf9c7df47fc17f710b0924d412b92e8614"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf51de0e33baa813f230099555591e5ddfb26be70919558b336e06f562727848"
    sha256 cellar: :any_skip_relocation, monterey:       "a3aac69cbb5d587718cd850e7a9ab1c63ca99b6699740234b5e3ad9cf445a703"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6c2994ee60080bbb263867ebb311e449b3818b67407a2aa71783311413791a0"
    sha256 cellar: :any_skip_relocation, catalina:       "4e9803b0db3622b31de5175a57969422bc2f7f894ebb6a71e00642f283a7ff08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a70552aa27f87a8de1cd77186f32398eb7e9371f25368f3dd6403e396ebe88ac"
  end

  # Bump to 1.18 when x/sys is updated (likely 14.9).
  depends_on "go@1.17" => :build

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
