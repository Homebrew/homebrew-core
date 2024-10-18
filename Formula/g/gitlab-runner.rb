class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v17.5.0",
      revision: "66a723c34024e52822760bd91e222375aa1ce9bd"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33ea1d1d525a1d201a0aded777e8d53c0ec74590acb278503ccf0a8e83dd4bf3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33ea1d1d525a1d201a0aded777e8d53c0ec74590acb278503ccf0a8e83dd4bf3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "33ea1d1d525a1d201a0aded777e8d53c0ec74590acb278503ccf0a8e83dd4bf3"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3f7bf9208fc7fc4f09ecc3e5af9ce9f7fb9b3c53d83ed1284b418ae28bee882"
    sha256 cellar: :any_skip_relocation, ventura:       "c3f7bf9208fc7fc4f09ecc3e5af9ce9f7fb9b3c53d83ed1284b418ae28bee882"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a21b4d96ef3e4d16d1bc50630623d675655e6036869ce85f8df2ea44460e6179"
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
