class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v16.10.0",
      revision: "81ab07f6dd8cb2d577396a20d059fea7086e0d81"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "77726c9125e8d4367dfa668835d69c58a3955f0125a580b3db6a0f21619a6516"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29bcd6f5e4f54c0daafa6829e2edfd6907db5109cdd95684d6165ff15c0bacf0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ca688caf3b9315f0da94096c40a687f211ac66eb92a47c5b2cfb8bda2cef5aa"
    sha256 cellar: :any_skip_relocation, sonoma:         "f0076615048d9993a1a7049dae6b4519cfe3b88d9b66dc8ef9b05ffc0d682649"
    sha256 cellar: :any_skip_relocation, ventura:        "7f6f80bc537a651050641e8d0dc59d80ad5046853c7c9f5d11344eba7cf0c104"
    sha256 cellar: :any_skip_relocation, monterey:       "cea013a3ffbc6fd2ea531cb03b1df7fc90aae479702f0be30f99343ad8f753c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5d4f5d2db27820d67f1fc3ca327d2fe6433e5c69f6e9674be3d4217bf8cc40c"
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
