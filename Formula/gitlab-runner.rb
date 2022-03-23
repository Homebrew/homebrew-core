class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v14.9.1",
      revision: "bd40e3da0ba8b9632f8e8d73c2fbff447ab037b3"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35bbad730547c39f53e2c9dd9c33bc0a55196dbff2f9a66a469f0c247b708a30"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8c8c03c79edaee0dbc2f13659e4305e859906757438d22edfd6c9fef22031e35"
    sha256 cellar: :any_skip_relocation, monterey:       "f3a8cfb4aab498d4a831250993ca97d108de0ab0f7cb31490420cfa52a7f3935"
    sha256 cellar: :any_skip_relocation, big_sur:        "9997bc19a7ff7a8d2425dc41cfcd5b36c2980dd384c06cd6372d969c0debba10"
    sha256 cellar: :any_skip_relocation, catalina:       "33cfa780fe31dbe3881bc686582d89a323ec665992b48978aab608c75b6bfad1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78135ba81dafb50df792e45b52b5696d63f052822a64451696fe9d26588c9ba2"
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
