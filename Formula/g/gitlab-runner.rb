class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v19.2.0",
      revision: "39acda302cba6db0501c3eb1937183e799ebadf8"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "da385cc0256decca6d1f611718d0ad1de287aa5526381089fdaa84e081bd8571"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45c12ca5e26f8f73c1ce83ff9b27e8e1997a3227c896f8e83918964b24b4a798"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ced77e0e2e1bbddc607833968983447c4c9e696cad0d2695a78f86b51c56084b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef9cb0099362a5c924f391329380dccdf584693d271f486f6e54a68722543cd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8fc782994af49e2faf8877a8559494084c70b39e8a99e7a9d401447d0aa8606f"
    sha256 cellar: :any,                 x86_64_linux:  "92547c64ca1dc2aa7099dc54218d974342259c56418844895608f1068ebc7021"
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
