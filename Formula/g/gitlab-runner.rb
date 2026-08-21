class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v19.3.0",
      revision: "9cbf0074ddb0e2f79d79f44406cafebf09117b64"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f83f084ba294ec853de262d1b3429b68fec9117d1c3d2b4daa5723beaca106f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "636534da09f91debc3d1804cac0cb09391394c437bf589647a7914fed0483f7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "477063f4610680e29189cbc1027332bd0096bf4cb2d19cb674aac21f18c6320f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3fb1253abeade7e0bb955597fcc66c3adcd37944910ae5b720f8d6cd7d2674a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a2d6b180df9625b17b4d3c1d79f2bda3614d7d5adeccad5663a0e6e9bcd148f"
    sha256 cellar: :any,                 x86_64_linux:  "62009750ef816031d4b99159aea4a16b022f7bdababe735e3b7bf47ac82964f1"
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
