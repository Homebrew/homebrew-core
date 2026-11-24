class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v19.6.1",
      revision: "9afb29f820608764d0f424eaaf388151d78c5355"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "d9ee51298ecc9ef00c3044d4a68dcc5714deb7561e9d5b720e391954de81dc6e"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9c99cf913c6fd8e3a0c58b0dd90b8c24b736320b3ab86b323bb29147ce68db86"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "467ab8dd70f7a86f133011ef0b6d779f4197e46b98d70664fcc989e78b4a7737"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "93010b03692113e53584282c9047684359ed6200e71f575b1a74ef31547b74c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "eb3e38ac5b4bdd7f93797a6f897b4163558456f3e2afd2aca545bb46ffc0a852"
    sha256 cellar: :any,                 x86_64_linux:      "7b479e2a34fe74d3deeaafcff637ecdbbb90a71b0e56f9736dd20fbf364cbb68"
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
