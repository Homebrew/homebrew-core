class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v17.8.2",
      revision: "f9c5437ef8a94f87c1fa3a450c36350d7767463b"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12a0cbda6c0b7859eec6a7993e56cb859cef64f323cfeefd7f08b3bd114dbe19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "12a0cbda6c0b7859eec6a7993e56cb859cef64f323cfeefd7f08b3bd114dbe19"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "12a0cbda6c0b7859eec6a7993e56cb859cef64f323cfeefd7f08b3bd114dbe19"
    sha256 cellar: :any_skip_relocation, sonoma:        "abcb8b764df111c0c2c552d0d39892ea1f942fad57c95f0a4feb2d35663e3384"
    sha256 cellar: :any_skip_relocation, ventura:       "abcb8b764df111c0c2c552d0d39892ea1f942fad57c95f0a4feb2d35663e3384"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "96ffe1e9dadd19df9a24a9e3e0d51d34748fbf54a8f0206ba2af5c0615730e7c"
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
      -B gobuildid
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
