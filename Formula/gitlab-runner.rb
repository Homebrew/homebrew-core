class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v15.6.0",
      revision: "b846829497b5fa1618d8270e687207356f795188"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce29cbaeab3c96a617ba124adf2453d1eb2c34dced4e151f6b94b8846c678828"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11b05a3d9ca55153720c9aec6bd3b5223090a062e7b3b520fe25ecda984a38ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6d1fe9b1e7df8afb48ebf66440d5cea7b82d62c4e461312d8c1060b59712a4f"
    sha256 cellar: :any_skip_relocation, ventura:        "4f582f4e89915a2c3d5b23218ceea95d773299c945889faddab43d9949c7d3df"
    sha256 cellar: :any_skip_relocation, monterey:       "c23efa92bdf49960af157ad0a5b07f85ba6c4ce3ee3e2cacbad79e1d337244c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "6765389090acda5b679ab51bbd2dfb5e173cb55b01167ab7ed95acc523761495"
    sha256 cellar: :any_skip_relocation, catalina:       "26ae7597144af1eb796e545752f4bef3b16c9b0c2687c22dc42f412b6b2f80aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6e0ace85c9ddfe5ed7318858c2288a923254322a780a93151546077acde09d6"
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
    system "go", "build", *std_go_args(ldflags: ldflags)
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
