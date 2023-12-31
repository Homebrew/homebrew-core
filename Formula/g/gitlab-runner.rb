class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v16.7.0",
      revision: "102c81ba6961a31f8a8c6549f2ea7d447334fc9f"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "461e05dd35cb6835c70b0f249cc7821fddfc2a2a49c7d4ee130b9a0afebcec47"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b50bd5e5e3c89475a817893fc276b0bcf2cd1183d3bfa35afe0043f99d2afec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70462dcc6ab19e08a835043a7493df54fa4eb9c6a5c6fa579c233d1ae3a633c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "dac7866aead25393c7965db4ca8c22288b5bc2d40932de9224e23093fe7f88d2"
    sha256 cellar: :any_skip_relocation, ventura:        "34407f85b32ea717ce636029876423876a91f818e980bfb99238858955f6d4a8"
    sha256 cellar: :any_skip_relocation, monterey:       "840e6acdc699a028d82e45ec3ec5c7521022d6766e466ebc67449357ca91dc60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "73a4bf319d2214f85264b8e081be074b11bee1734af8c60e7089f054eeda0075"
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
