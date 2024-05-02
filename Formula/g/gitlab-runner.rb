class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v16.11.0",
      revision: "91a27b2a875113abd0e7dfce722e0ec5497b5013"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a19c7ba8f5f881f259fd2a24df5842963a52d4638c6a6f71574c196295e715de"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c48550c021cd93a9e1795f8282b9dc135aab21e4d789258cb17b707872ee281"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2162fc902110b08b03e66b6844c90cc4e6c6d18c1382d9094f77adc3696263ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "ee8ce578d2971f5552e151159e250c52424dc7a7ec2bd94d9459a703362a7f9d"
    sha256 cellar: :any_skip_relocation, ventura:        "663eca62d00d5c62a8037b1ca423e58a40b78aa9a90c653546c29119e983b909"
    sha256 cellar: :any_skip_relocation, monterey:       "0d48d8d9202480d18ea9729785764626ac54ba87232f1c2f2b19e3403457bbbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8882c32052fbedf0497666123b678553c9e32e10f8a5896218c722346312eb06"
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
