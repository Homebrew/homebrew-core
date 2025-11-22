class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v18.6.1",
      revision: "b5e9c6d04ecb017785f6d475dbc88868c7ff7fc1"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7aa7a1c5deae47039f0bab2a3759ba6187e1dfa4e665777a11a309183b423f48"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7aa7a1c5deae47039f0bab2a3759ba6187e1dfa4e665777a11a309183b423f48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7aa7a1c5deae47039f0bab2a3759ba6187e1dfa4e665777a11a309183b423f48"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce4f90540298a97ab6201a4826aec0a4a71973204d5d946303a98bff138653d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de03dc75fff6f2c13818f19aea3a5aa4da2693050e9e21ee670132ef63558eca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d2bd532a5bb6b629390de47c6c6fc1e29c222ea8007d29bbf4a50489b197ea3"
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
