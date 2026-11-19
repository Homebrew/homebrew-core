class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v19.6.0",
      revision: "9e4c6b50fd8a81ceaf2ee5c0b4d5d1c6c16067b0"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "354609d557b6e07371d68aa5d70c8a99034b47c2525624710bce251d95069807"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "42fe5d9df12b0c5e4fab0999a0115b8a81179cb991b4be0fbc3c48d82adbf4f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8b6b5043a11722a20971a9a764924e3dc5c3db3140dc28ab62f3e785c7846d58"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "86844943f96d85319cc3e7dd730fb401e416e80a97c434b2949742d6a01b113a"
    sha256 cellar: :any,                 x86_64_linux:      "d5abd605d6191568f7e58050cd5135157e443354efce6bcc1eaac73e89d0c02e"
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
