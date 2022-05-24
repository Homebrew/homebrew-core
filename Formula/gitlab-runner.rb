class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v15.0.0",
      revision: "febb2a09664bc5ffc8d2b69acfc4565c42e5c7bf"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d549612760f729516d804d6c91a4786cac217300e42d31920d476255965f9df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4f36ade6a30db6ebd71192634b4718a81be978be8249a9c7326132e9fa138a4"
    sha256 cellar: :any_skip_relocation, monterey:       "92f52b71549df43b9b6b5269f21fcaba090ff9b4bb5eb45e43df1031f67c881c"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b8ea87c53aa66410e28d811c5ca9d69897f4645ca4134019ff44b09a7c3038f"
    sha256 cellar: :any_skip_relocation, catalina:       "db51805c930d19f0f00c62f2cd8475e6d5c5e176cd0c5a0a0cb52fdf6e69d219"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b1cdd74542c5636555915ff93b0fa52f16ddab2d5220b366d10df270bd57fbd"
  end

  # Bump to 1.18 when x/sys is updated (likely 14.9).
  depends_on "go@1.17" => :build

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
    working_dir ENV["HOME"]
    keep_alive true
    macos_legacy_timers true
    process_type :interactive
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitlab-runner --version")
  end
end
