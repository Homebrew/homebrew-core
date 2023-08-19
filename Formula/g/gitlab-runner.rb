class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v16.2.1",
      revision: "674e0e293327b262d8d39a9d67c4b59ee50c4ff8"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c398b064e8420237251c5fa4ee99a38825d501d89b6e56c3ed2e34a85e374ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c398b064e8420237251c5fa4ee99a38825d501d89b6e56c3ed2e34a85e374ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c398b064e8420237251c5fa4ee99a38825d501d89b6e56c3ed2e34a85e374ef"
    sha256 cellar: :any_skip_relocation, ventura:        "f40da64cc516488af6de5ae2c840d98eb0d3c347f61976f285e6715340767253"
    sha256 cellar: :any_skip_relocation, monterey:       "f40da64cc516488af6de5ae2c840d98eb0d3c347f61976f285e6715340767253"
    sha256 cellar: :any_skip_relocation, big_sur:        "f40da64cc516488af6de5ae2c840d98eb0d3c347f61976f285e6715340767253"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "432b2a2e03ddcd7a0f3aeab4a9682e8d2c566dba8dad9f9dfc727919579af87a"
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
