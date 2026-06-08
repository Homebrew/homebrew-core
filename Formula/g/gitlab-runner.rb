class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v19.0.1",
      revision: "c2831b75a3ff0782dca8f64498cbc6f71c76819e"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "64c690af940603c3cefdfd3eeacb8bedccd83503683385910e24a4e3fd9eac37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33e6e7c201f1a2519f973f91bd2bc1c6e41d257637cdf8672344c70e0ecf60ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9fbe40f24e186c932946e9ecb0f3282d58248f67bcb92b3c9d2307461d4d40f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "73a315324682d6a63dc4517d28d41e209c236a66d99a13fc99a635bc51f972d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a06c9f1c91ee96980912c8ba64c3e3f0d527b6047493c5cd30c31a1ef61ed11"
    sha256 cellar: :any,                 x86_64_linux:  "95345c6a9df55fa4c684952989147405ed86ef412c327c8bcf08be2452215a7c"
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
