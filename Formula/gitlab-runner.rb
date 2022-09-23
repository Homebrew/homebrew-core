class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v15.4.0",
      revision: "43b2dc3d83ed12442f8a106ceef1be993797f355"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4036c3a7124825da13911ac7340784226631179db11de982a4bd6a0f5b834cd6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c9a805a8fb9e79f917300d5ccdb48222c3d99eed4cf1a66a546ac03c86e702f"
    sha256 cellar: :any_skip_relocation, monterey:       "d90e62de2883f8011123accf524a78f1c3f3b0a6bde1cac7d44c60bc3d262693"
    sha256 cellar: :any_skip_relocation, big_sur:        "bbb118c73a92536a0b0c004842e01a1e9e5f6f1a4e92d7d7bb25e85a01c572e5"
    sha256 cellar: :any_skip_relocation, catalina:       "9f0f468532f9cbe669ce034fe47dbea9f6ce716c3280829ba3b01575a7f4904e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b93bbfad6cadae66a178de99a60ff9f1b809b623f337a0f98327e00b63321dfe"
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
