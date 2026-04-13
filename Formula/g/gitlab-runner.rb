class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v18.10.1",
      revision: "3b43bf9ff3eba1a75461d386b76fea77694e26a8"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "072740437e928df561fd18b7643bd1f4fecdfa767b0ea662983d27ab65a9c9ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "011b80e1d2afa2923ed002bcb88f2825271a9027d3fb4460328b3e1a0173af68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57166e5478fe336e69555231764188234846f592d4de78461eb3abe1c70349c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "ddabe0a2cffce5d917fb67e59aba8277a8bedb692ae7063ed9a615c8bbe40f3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42df13015fe7a78b47db03a33c385344c1e9a937f485c85362306c5ac9514395"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78c21e2eb414632c9ac50b8fe08378a00693f2301b22aca4f55a071eab4bee8a"
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
