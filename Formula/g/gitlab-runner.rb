class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v17.8.3",
      revision: "690ce25c4e607e5f993cf439439ad6acc77952ba"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a3bf9d3de96b481186052cb61d9a53a1422ef8d3c7efdf2a6c1bcd93b5d31c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5a3bf9d3de96b481186052cb61d9a53a1422ef8d3c7efdf2a6c1bcd93b5d31c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5a3bf9d3de96b481186052cb61d9a53a1422ef8d3c7efdf2a6c1bcd93b5d31c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "0f0da44660de9e186a03a56b18eef1b28bd34f4972335303c5aa1bbbb5b9eec6"
    sha256 cellar: :any_skip_relocation, ventura:       "0f0da44660de9e186a03a56b18eef1b28bd34f4972335303c5aa1bbbb5b9eec6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c8d362ec5f623eb89f8f0655b27ff76596af6b0f31082bc09284ee6c1a681a16"
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
      -B gobuildid
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
