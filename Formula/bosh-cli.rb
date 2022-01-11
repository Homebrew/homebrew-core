class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/v6.4.11.tar.gz"
  sha256 "f5d0af6af086c227be0caaf8bc06113355d0bf9bbc258cec33ecbb2c9d29fd10"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a15feb1c5d39efb166baba609430f2c71ffbe308af801d9d9596e8c124637716"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "881cbb78cd0b7d4b3bd35c48542582e368b486d0ffae852edaefeb06e91308a2"
    sha256 cellar: :any_skip_relocation, monterey:       "4363269bdf421133a832bdaf4dc4d819645e70ed4d12143c8f185ae4ae064225"
    sha256 cellar: :any_skip_relocation, big_sur:        "dc327027e1002a1d4caea376d63534f9a38328e6afa7c905606d9c2d5385e5a9"
    sha256 cellar: :any_skip_relocation, catalina:       "be5cc77a02717042f20a89130a58d57db3755ec153bd390142d7dcd3b66107b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "baefd8172fa59418b63e39df0f41067b1ab45215cf2ad465d7564625b6f8b637"
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
