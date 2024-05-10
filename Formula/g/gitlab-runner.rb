class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v16.11.1",
      revision: "535ced5fe5988490061ce316fc49529575e8e58b"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "115ccf22e51481333720d52acd336e78dcb2c3c05b06c28338c55401e8e93612"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea27a057aa2820ebaa4c0ed581ae2435dc1047cceacdce782184f9183783fbc4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9198695833c2cb6ad40dde607674ee1e241c29f064ef4a4dc682fdff5dbf31f4"
    sha256 cellar: :any_skip_relocation, sonoma:         "df285ba62ae2ca5ec6b4d5ca727da38fbc94628c40dfdf1cc0e717b5c44e7cfb"
    sha256 cellar: :any_skip_relocation, ventura:        "2d82044b48d2ee30456702d6156a00408105d86cf422611a73edd2036f7a5fa0"
    sha256 cellar: :any_skip_relocation, monterey:       "aa0c10e0bfd56613e28829750f759c9bf194c604fbb37e007571e96e6cbf4151"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "097c4ef7f397451e915a33dcbd0334ffc49322ee1da04c0989f98f40bca1e145"
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
