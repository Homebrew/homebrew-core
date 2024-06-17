class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v17.0.0",
      revision: "44feccdf3a5f65891017ef143a78c7a0d22bb63b"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0fc8a467c1a49a8cec12f21cd577a43489be941608fe5829d620bfefb4acd2e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aeac604b2aa5cee922cbe9bc191aac9312a72a5d8fed3f23fe40a843d79267b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e6110d6c70dc6656e5954d8d5b852e813fd7ad7afe30f9bf0e91ea908c989b1"
    sha256 cellar: :any_skip_relocation, sonoma:         "00d2cbd9bcb7ff466a27e45270d4455c07c3575a8d548fd9b132c64645832889"
    sha256 cellar: :any_skip_relocation, ventura:        "b4bb062d457fbcda057049bc577a2a836ba1bea3e37fa1db0668adfddaea4d71"
    sha256 cellar: :any_skip_relocation, monterey:       "a37ffdd4caadcb6b438e4d2f80466479224461688c8a673a2b237488f4e6814a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a076d99cc973eaa39fab5585b7bb63caf364b3fb3d18b6b2c304020dddee73ea"
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
