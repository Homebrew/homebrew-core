class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v17.5.1",
      revision: "affd9e7d9de6fb141a5558efdd55b8d748b5f0aa"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "871b5bd321e246c32ff1b5dfed70b844254fb01d9f17cc4cd309bde624c9ad06"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "871b5bd321e246c32ff1b5dfed70b844254fb01d9f17cc4cd309bde624c9ad06"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "871b5bd321e246c32ff1b5dfed70b844254fb01d9f17cc4cd309bde624c9ad06"
    sha256 cellar: :any_skip_relocation, sonoma:        "319c16ef3fd014afd83a8ead66ce0408be173fbd57d00f58d70f81a4d6d3125f"
    sha256 cellar: :any_skip_relocation, ventura:       "319c16ef3fd014afd83a8ead66ce0408be173fbd57d00f58d70f81a4d6d3125f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4216697c0aaaa52d6de8bc68c83ef2288b29436e16da3a662aedbcae5419200b"
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
