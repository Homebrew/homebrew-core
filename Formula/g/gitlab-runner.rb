class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v18.3.1",
      revision: "5a021a1c14edadc683ee4b1f0a00182ec3ee636a"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "73f3c6bbedd8563670243a9c1e2577de42d6e421d36fc7b557b0f646c6fa0af6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73f3c6bbedd8563670243a9c1e2577de42d6e421d36fc7b557b0f646c6fa0af6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73f3c6bbedd8563670243a9c1e2577de42d6e421d36fc7b557b0f646c6fa0af6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "73f3c6bbedd8563670243a9c1e2577de42d6e421d36fc7b557b0f646c6fa0af6"
    sha256 cellar: :any_skip_relocation, sonoma:        "4761c775fe682a5b629d78773d2ed612413fbde283fa223f3205f39b6eb75cb3"
    sha256 cellar: :any_skip_relocation, ventura:       "4761c775fe682a5b629d78773d2ed612413fbde283fa223f3205f39b6eb75cb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eab56ba765cc27f3344e9bec7697d8cfb04d346ca4b9552e8c14e86a08777af6"
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
