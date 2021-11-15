class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v14.4.0",
      revision: "4b9e985ab8986c344903898ef682a122718f9632"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff7fcb67c66534a36b32d043c573005421ebc26fe87fe09937cdc9164708b900"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1313bb413961d78b9fde57a3a14dc8642dee3f7d3ddf4fefb354dc95fe49ea76"
    sha256 cellar: :any_skip_relocation, monterey:       "4f997780c8add77429da13d9bf3cbdfb51f44c042f8e27cbbf3a4a88b3f684fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "d20050b6390ae734ba30c7dce568323ea9714b9b0c9eff7154268a1028a73aa7"
    sha256 cellar: :any_skip_relocation, catalina:       "e5302f85731f53752c309fcc8f1157ea58e7aac8453fcd4a331a9e35e5a18b4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a565ac79ccb691a2af326e15c3d10ae92c4355cbcfa8687b1b88a176dcf815f"
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
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  service do
    run [opt_bin/"gitlab-runner", "run", "--syslog"]
    environment_variables PATH: std_service_path_env
    working_dir ENV["HOME"]
    keep_alive true
    macos_legacy_timers true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitlab-runner --version")
  end
end
