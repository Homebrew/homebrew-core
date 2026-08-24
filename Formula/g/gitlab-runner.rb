class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v19.3.1",
      revision: "a16f5092084b0373ebc30c6910f8972997e44b70"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d17474e7a3491ad7e956c70327a106ccb0546f26b1bd1ecabbe19dc8ef74871c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6b5a34255ce7cef50c3c686afea6e2d940f06c3e8aec532585a531145fe3284"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a23c754311cd5a21196b80babac8b2ad838ccfc04c20fb705ee47e62fcb29e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "7a9f756db897ee37db17f94a14531e43a798622a8160c747313521160457eeb2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f93f56b5f35baa0e61516a32b8b671f62581a4c195d17e03e1c57bb9caaca3b8"
    sha256 cellar: :any,                 x86_64_linux:  "b79bcc9f09439debce38a5c4348ae7dbdaf84c0c47d6e3dd58b1111395b82c61"
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
