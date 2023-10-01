class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v16.4.0",
      revision: "4e724e030caf32c8183d1a0a02c3e647ea56ea65"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2b3c855868096d4242031928e50b9eb97d6eddbf77a3383bc7b1822f38d65ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4792aa1c70d54bd64eeb54b9b356a10e42ff9b5b40e567d4b095c3d5bb00a57"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b5265a676a6dc9bc83bfe9c04266f586c83ade1239216b4cd91a5ce046b9b92"
    sha256 cellar: :any_skip_relocation, ventura:        "c333cdc3d0c7614ba7ae172f8f49e3a0932dfaae0a38669a4601217311197fe3"
    sha256 cellar: :any_skip_relocation, monterey:       "b70d95b3c6888139fd9ee192c04737b1cc188a56507fe402cea96c2f1ef9c1a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "13f7755d93cc14485400625dbbc1e0f530412660364ca26a9dfe72530b4f4fa0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae32f72009fc75982ac323559dbd25f26d2810f6a4229d7a9acd1758cac6c737"
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
