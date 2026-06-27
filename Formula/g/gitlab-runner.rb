class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v19.1.1",
      revision: "24b9b726e614dab77eee89b001745cf9f890e0ce"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ac5a12fe63432a6fdc945f6b095403dea9d3cf0db07e37461515362161c1103"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "29ffad6ff33a10c33a03b41f8139a06816be400d515c5cc14696d42a6364f566"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "586f85b0f66c5d52a9b9b579fc000e2bd0c5905241927fb6e647190888ab9ef7"
    sha256 cellar: :any_skip_relocation, sonoma:        "30e3424b2de95ae01be7ac4c58787e093f1e1f4af08ca5d0f2228f2f989a5fde"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1d7b37f071e925727168779a023c6a22e08b7f802e0f29adb3aebcaf7b613b2c"
    sha256 cellar: :any,                 x86_64_linux:  "e27f20a0acb4d9340259c10905a1437a4a8d7a477336d3ffd88b4fc96f9ed4d8"
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
