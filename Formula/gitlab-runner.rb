class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v15.8.0",
      revision: "66039dd945a2ab714242dcda254b3a999b57b469"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36ed39ec46b8544c29b6203b513320dc0424b295e3ca499ffa3b5ad5786f735e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34604c85c5fff0beacb5f431841e3123dd9f8f45c236a4bd6a98cd922b646dd7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1962c14f9351e8af641e02527412b869c6c7b23e02770972ec4311c24d453dc3"
    sha256 cellar: :any_skip_relocation, ventura:        "fecb129f3fe4bc1ec1f671f8e88e91a71ae8d5099aa1cd9095a14e45d5cff45d"
    sha256 cellar: :any_skip_relocation, monterey:       "2652f54a9f72d61604ebd38efcb88664600e2102bc4a44efdf154fdf6e98b125"
    sha256 cellar: :any_skip_relocation, big_sur:        "ddc7fd60c887ec77236e2e3ac33c9df4eabf26b282a55e8484c09587c8b67ac4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65f4d5777e2195f04e2c51c669aa2909674971455b4ec384cbaad13cf286a1b7"
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
    system "go", "build", *std_go_args(ldflags: ldflags)
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
