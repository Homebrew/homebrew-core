class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v18.11.1",
      revision: "5265d41dc1f09753511f4e2e6899ffed12cdfad2"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e11db0380fb6f5bd3caa929400d15157e5060c663ac32dce1251198c2f3fd79"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c702f2439943e375993df1777b9d66e586553be4e90ce206c69374597bb8e4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee581c35425a703b69bace296bc10936c4a128bf6c862659d888705b4c6557c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "f20dc0001895e631d5f11f4a71660345a7f809fb4d1f7d60f38f04e2b04f0b31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fbb0823a5beb42f805e564e8c7b02cbd3628ca35d2d6765d915eb428f7ffdde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "42e0c903fd1ec179318fb363074897d60991871083d3bd94e90b5fba4c901203"
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
