class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v17.9.1",
      revision: "bbf754883635d6b878baf27248e44f8f65df0b2e"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5849b263c2d03e1b8e8415def4466a4dae35a35fe89edbcd2ea13842b71e5389"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5849b263c2d03e1b8e8415def4466a4dae35a35fe89edbcd2ea13842b71e5389"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5849b263c2d03e1b8e8415def4466a4dae35a35fe89edbcd2ea13842b71e5389"
    sha256 cellar: :any_skip_relocation, sonoma:        "a564aeeceed9a461b333c54852f0117ffdb5ec5427b8d64a054639585dedc4bb"
    sha256 cellar: :any_skip_relocation, ventura:       "a564aeeceed9a461b333c54852f0117ffdb5ec5427b8d64a054639585dedc4bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b42cc772647a88584bb7d66ef112a36a79a739a7aff6d9cbf17b960c89608ce7"
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
