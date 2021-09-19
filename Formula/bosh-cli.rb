class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/v6.4.7.tar.gz"
  sha256 "0065debd58de79fef74592afb994381c3b261585ec9085f9af50a448f3cf097e"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0442602a517d19186b23ddd229fa8f9692b688585c8c18b26243c6d0490bdb0f"
    sha256 cellar: :any_skip_relocation, big_sur:       "fcd60369a7a495aab9edd4b97c0a93c923bd6735d955d6429b0fd81dd949a883"
    sha256 cellar: :any_skip_relocation, catalina:      "17cceb653f145b6dd17c862ad3f6f6b8b189ce8b53626ef9dfcc08eaf10eca9b"
    sha256 cellar: :any_skip_relocation, mojave:        "e84c063d20796732f6de149c6b77b3cd78e914d9dbcd0ead0210899284a1b339"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56fe21b40a0feaf48b8299350e91e9d8ba1cf3a9a43065820660938b1590766a"
  end

  depends_on "go" => :build

  def install
    # https://github.com/cloudfoundry/bosh-cli/blob/master/ci/tasks/build.sh#L23-L24
    inreplace "cmd/version.go", "[DEV BUILD]", "#{version}-#{tap.user}-#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"bosh-cli", "generate-job", "brew-test"
    assert_equal 0, $CHILD_STATUS.exitstatus
    assert_predicate testpath/"jobs/brew-test", :exist?

    assert_match version.to_s, shell_output("#{bin}/bosh-cli --version")
  end
end
