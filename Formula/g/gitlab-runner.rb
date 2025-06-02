class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v18.0.2",
      revision: "4d7093e1e4eb37e77441dc0f9c83e0af7a9d4180"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73d1466c2b90dda3eb93583767756680416ab55ce049d4a02633df7b43e8e1a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "73d1466c2b90dda3eb93583767756680416ab55ce049d4a02633df7b43e8e1a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "73d1466c2b90dda3eb93583767756680416ab55ce049d4a02633df7b43e8e1a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "043f9f82c10e4529bcb6da5238fb219ce3ff440a90ffd3a5a376cf57208ca2ba"
    sha256 cellar: :any_skip_relocation, ventura:       "043f9f82c10e4529bcb6da5238fb219ce3ff440a90ffd3a5a376cf57208ca2ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e117cd8f01fee566da3ea7429dd28dbebdd411c882d98ed94bd668d790b62d9"
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
