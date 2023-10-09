class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v16.4.1",
      revision: "d89a789a8800a94f7c2d98f0b9d85b79736b4f4a"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d758e68c9ca9703d3596bb9856e58abbdae4df3c0d491f0164f4d1dfb218244"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01200749455286c13ee200230d78511e42c3b0f9c0cfddd1d96081c733aa45d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad90d699d14ba97e006319f503f731a02e5b435e5ba12fef979e80230c9a0d31"
    sha256 cellar: :any_skip_relocation, sonoma:         "8d7b39698bd7366167bb289551ec1a2301ac127c597f2a8aeaa5055f0e760c84"
    sha256 cellar: :any_skip_relocation, ventura:        "348f72d9c063073b8a8003ce512ea4b78e0a68aebbe57a342233843ce1e159a2"
    sha256 cellar: :any_skip_relocation, monterey:       "a980026e7f818514f2f5cbfdfed7bfe4d1b8439249405be24661e4422306309d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c9455a18d8f4714d385eabed87e1a482eef4df6094f65521089640f04dd6d53"
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
