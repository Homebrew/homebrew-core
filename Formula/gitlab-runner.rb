class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v16.0.2",
      revision: "85586bd1a09427c6b206aede8ff97255993b79af"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1acb7fda8f01ad10287f7d3ed6797fcbe803bcc1be005ae84001c76887ef02b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1acb7fda8f01ad10287f7d3ed6797fcbe803bcc1be005ae84001c76887ef02b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1acb7fda8f01ad10287f7d3ed6797fcbe803bcc1be005ae84001c76887ef02b5"
    sha256 cellar: :any_skip_relocation, ventura:        "7b6f9b1d2a508d220c5dfb1be0f208acd3f616cd65280c33aeb52f62614051e8"
    sha256 cellar: :any_skip_relocation, monterey:       "7b6f9b1d2a508d220c5dfb1be0f208acd3f616cd65280c33aeb52f62614051e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b6f9b1d2a508d220c5dfb1be0f208acd3f616cd65280c33aeb52f62614051e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cf486f25157bf5df7ac927f7160e01681631f36243d2869f72f42e331f438f6"
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
