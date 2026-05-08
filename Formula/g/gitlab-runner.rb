class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v18.11.2",
      revision: "6822948553cf9cba4bb3c063f36e1a6001746af2"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4491f910db33d9a4472146336e53511a96a7ce45c438b5c06978a402c3b219dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "81ccda8f8479537022e22d111507e29ef3150fbfdf22a1d1c2d29c551f61f4cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e02308273edce22005f600c91ff52139dfbc9c395c152e9fca72c30e70e21eaa"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a5fb260605701d3f0df83132f330ff3d9ddca781c2f986cf9bceac9a0cf0e41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "191236e2a31973b2510d469c0e55d50a492300005e2de490f0d5ccaecf1b4ef0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fc504f2feed98c2178d3ad44489f6fbed6f1626ec8ff811162a1a2e3c334e13"
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
