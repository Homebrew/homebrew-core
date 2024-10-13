class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v17.4.0",
      revision: "b92ee59097e3701a887e0fc2983f5477fb164a60"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a31ee0ee3eb427e55428b8b58c2a153be563313579a796f575e0ec6e72007c3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a31ee0ee3eb427e55428b8b58c2a153be563313579a796f575e0ec6e72007c3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a31ee0ee3eb427e55428b8b58c2a153be563313579a796f575e0ec6e72007c3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e9c111084a6128dd45a780095b27dcefb1bc72264c8547f2fc52dba42d2bfec9"
    sha256 cellar: :any_skip_relocation, ventura:       "e9c111084a6128dd45a780095b27dcefb1bc72264c8547f2fc52dba42d2bfec9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd0c750ce5f49812071358527f402a5137cfe2bddcb4d50602df9b5a01d224d4"
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
