class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v15.5.0",
      revision: "0d4137b81e70f98c801f5c47411dc06a16333d12"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e85b07b9463d7b13c6eed317985308cb3437f4ccdb064bab014576a2f4644690"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fc7ddd00ff5a90ac18b79adff76af396869b374b929f212b3d26c125ac8077d8"
    sha256 cellar: :any_skip_relocation, monterey:       "5938ba3587d8a8d01a5ba4f45ab9863f8b4c47fd3e3bdd522458a2c1ae7ee579"
    sha256 cellar: :any_skip_relocation, big_sur:        "c97d96f686036dfea695957804f879e0cbd7b0ff7af704e770c135d22e0c838d"
    sha256 cellar: :any_skip_relocation, catalina:       "9e35112024e18dc978971bfc102e0c70b0b84a8ad14a1f276d7accc4fd4201cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a61b7cfc8806ffe333668045600a3726418433aa49ff6c26eb4a57d86998f01"
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
