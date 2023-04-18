class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v15.10.1",
      revision: "dcfb4b66a1f4d78aeb8bfdd1647a7ccb5597835d"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f23f7b8960403693b1dbe3a1abd329b3092df4c7242ec9592062d0db4d31d0da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f23f7b8960403693b1dbe3a1abd329b3092df4c7242ec9592062d0db4d31d0da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1cda4405566ac3c2ab82fff0a8e764df7625d2d077c3f1e45199351a88007f83"
    sha256 cellar: :any_skip_relocation, ventura:        "260ddc645d9b15b3dacc80e94a6ec0e62a2699daa853b7eb661365d4c7350732"
    sha256 cellar: :any_skip_relocation, monterey:       "260ddc645d9b15b3dacc80e94a6ec0e62a2699daa853b7eb661365d4c7350732"
    sha256 cellar: :any_skip_relocation, big_sur:        "9297311b25fb0068d9797bd3ece3ff42ce327d2acaadb71ad21c08cf7617e4ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9a1eec77c65259107c237b058a3f94191e331e62229d247559ce3f4e9eada56"
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
