class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v15.11.0",
      revision: "436955cbc8f66f59294ea16e5e538fec8ab44a02"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6ff8e5b384bfadf37229bff9a496c5cd07d4a3b703d8adf9083a3648c7f9de5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a34396b5f2969332e64ce78e295b7161856796e24a2626043aa5d8c2481bc9da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a34396b5f2969332e64ce78e295b7161856796e24a2626043aa5d8c2481bc9da"
    sha256 cellar: :any_skip_relocation, ventura:        "c4b32dae21f97d3f3dc375f6643854509802504edc4a48a0351862de6611cee9"
    sha256 cellar: :any_skip_relocation, monterey:       "c4b32dae21f97d3f3dc375f6643854509802504edc4a48a0351862de6611cee9"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4b32dae21f97d3f3dc375f6643854509802504edc4a48a0351862de6611cee9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8426cce940c060e83f4bc151369201be923c2c01ac4985533b14eb59526e5708"
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
