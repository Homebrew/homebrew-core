class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v18.11.3",
      revision: "ad1797b33167da20f3d158339e0081c0fa9c4dab"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2c3f447053790b4b4c1da8514aee529a2e1e8bedda5757acf05af1e73b71f32"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "927383395bdc73d984e849ae290ad57a4c94372830443e1cb3ebd63d7dc3b034"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb7f758dd71174855e389cb26a5c4c3dbc7ca4eb19174fbb766269190b9cd37a"
    sha256 cellar: :any_skip_relocation, sonoma:        "1dd7369ffff8c906a796d4b8a42e90b1c6a8c2c4790c12af81fa81b4097140c4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38b09665faeaf9695291e0945d385dee53ca269f31ebeee79d9b0ed48dabfeb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53359310857b941b771dd8e2f29a7c4ebcc455e2ccac4a2fe7a11295e3c884d9"
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
