class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v18.6.3",
      revision: "dbac4904553947d823cf632ac928023ec2c9a987"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "804bc2ca796d4f98c20980670bc9ba23ae047a9270573eda3209c3a6659bf0fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "804bc2ca796d4f98c20980670bc9ba23ae047a9270573eda3209c3a6659bf0fe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "804bc2ca796d4f98c20980670bc9ba23ae047a9270573eda3209c3a6659bf0fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5f593e48aadbeab21a7b7a1179517e4c0cf8aaf8d3dd131650e6c08c505bc6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "096e876158207f4bf4d0597ca8fe11eef53fb8a598223562ae71e5beb22e9487"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a26f9d0a44b4dce25b263ec8c3b1db33b46e3a6a9bebd82ac1e84877af26871e"
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
