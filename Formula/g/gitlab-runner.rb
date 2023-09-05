class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v16.3.0",
      revision: "8ec046629e5b2aabf180f4728052511961da7940"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02e8a510abce8ba5b1e930da858d90e26ca3098aa40df51f5e08ee57264723ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfb32790404c6572f62b7678cc40858964f4b3af1ceca7efbf0b8af4859a05fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e0391c116a38ddbfafecf7745870bf5ba2db7565e0eff47b792ee100dbea54c"
    sha256 cellar: :any_skip_relocation, ventura:        "24db41afc1270a83845d6f58c1e35d405f5d2913a2c304d70bd2d0f9648e88bc"
    sha256 cellar: :any_skip_relocation, monterey:       "cc022db39559bee610cc67ac74e5e0447cad2d6a8feb36268186a2f47bed06e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "ddaeadeb863ce919aca507153f3b2768301855e92698efd4a96c1b7d95dfbc7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e43ec1efb33f137c1f2af2cc5b11e04e7f29262f890e20e2ed9ac0f2443f9aea"
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
