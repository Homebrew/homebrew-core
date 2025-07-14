class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v18.1.1",
      revision: "2b813ade3b595454465a9ea9d09413592826511a"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea0fced61a91b10e414f4c42dc249db70a00de80e7ace07ea9ea072913905f4d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea0fced61a91b10e414f4c42dc249db70a00de80e7ace07ea9ea072913905f4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ea0fced61a91b10e414f4c42dc249db70a00de80e7ace07ea9ea072913905f4d"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa55091f4d40641e1d65fe31955dad7f93ae07bf8916c6c6aa690bf4b43cce1e"
    sha256 cellar: :any_skip_relocation, ventura:       "aa55091f4d40641e1d65fe31955dad7f93ae07bf8916c6c6aa690bf4b43cce1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "758679a1968b173a7985120c20e4fb747db6f70666cb9b54d2f01d00451f45a3"
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
