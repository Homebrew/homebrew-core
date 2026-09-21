class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v19.4.0",
      revision: "ac11717ac8896ab127626892a49271a41efa8bfa"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f3269f7927878e531cb30e50bdf4003f1a2d83e9cbbf788194faf415ec987bbe"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a50fe76ae16d5e293c8c907ce271622653880cefb38a83324980d16aa56c852b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9f758563f2696e7fae58049ff060e1ba295c58b69496887fd617e9094ddc6356"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e93682bd33ae65b525f60e8c361db793ac2e43e08cf1d81107b5ed2eb621fdaf"
    sha256 cellar: :any,                 x86_64_linux:      "0ff24864b4ef8ebea0815a1370dc4e8f35cdfa979f6e7739b35a9875eed2f23f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
