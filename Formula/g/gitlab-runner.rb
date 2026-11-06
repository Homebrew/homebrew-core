class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v19.5.3",
      revision: "33227fd48c5b411d0b49a74e129d187728abcc3b"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b494e1a8aaf17b80645e98d7492cdfed8784db42736b4c7aeb6b594ff6aa4b60"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3f74df5402f48ff5f5347cb8912fdf70748234e8cefad6f1a07f7175194b7365"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "27bbc901db783b1d5d82314f1049b0764ce861da30f733ffe8c23cc1838b9374"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a773eb960b4b91859a5cead320794c5f38d38d11a0a97a642d423c147a24d47b"
    sha256 cellar: :any,                 x86_64_linux:      "7cece8b78077181fe534e93271984446662ae9217e9a826c652cc94cda7962de"
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
