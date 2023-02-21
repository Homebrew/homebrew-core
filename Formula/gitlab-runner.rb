class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v15.9.1",
      revision: "d540b510a2100dd1d17e75e89af1c921ce107fb7"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f380097f6d798a54ec005388e2f8e547c0bcf8242e8dd27234be4529b0d34924"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4517bbcf08e8fb4b85da960eaef1953e3b3f753aa8982a76c82ffafb1e0a3e66"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc2e0eeabd77d70a79635896293a0d0c3fc0d252eba7146489317b017482807b"
    sha256 cellar: :any_skip_relocation, ventura:        "721c2068698b95be8d1481806387ad9c2b717d5dee5255e59aee52b4888ecc36"
    sha256 cellar: :any_skip_relocation, monterey:       "b28e08ee5a9feb261843a7dabac69e32f85ac3fab9b4d7d9b3634b96e35e3264"
    sha256 cellar: :any_skip_relocation, big_sur:        "baf0aefbb5f916144cb7a6b73ef12fe8931f6674d553615293d2f6ecb3fe5ce4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "832e650a61b06e0abdbfc2f8509cbefbe8d4c4ae52a60203b2b0cb953eead91f"
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
