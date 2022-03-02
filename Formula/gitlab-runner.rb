class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v14.8.2",
      revision: "c6e7e19481b317ef189074f20426664037ab8e5c"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09534481c4c806a871c51d9798be4f0ba6e3690afc67dc8c4716b7df75fc4b41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "baa7dae6facb7fd5f8d9d7c01a18bdfda515e354a06232033b28207d8dc4f307"
    sha256 cellar: :any_skip_relocation, monterey:       "326fb6247caab3a09ef5a23f216375ba2782f9c1bf647e5885e5bd469ca823e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e5995d7c77ee44ad14adc7cdc3cd2451a6ad6b6756d4d91e0528b3ceea4768e"
    sha256 cellar: :any_skip_relocation, catalina:       "c00f74b9b08276ea490efa3dc355b20236d0e059bac17850a2de68bb1cb8960e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f35695e9a23e1990e8df8c6b20e6242af74cc280bb718638757be9933ba15ae7"
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
    working_dir ENV["HOME"]
    keep_alive true
    macos_legacy_timers true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitlab-runner --version")
  end
end
