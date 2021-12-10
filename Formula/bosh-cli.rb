class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/v6.4.9.tar.gz"
  sha256 "eb7a82f390d1a5238e0ea9d8a2d545ffc323ca91a23481185879963cc40be2bc"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e80dd8bd81a680bf273fa8b1f9021246265dc99e5eccbafa4cd166536150057"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56a429c66ea3e4b31e822757f9d2429530e6ac74a21e6cc970bc1d6eba8f2443"
    sha256 cellar: :any_skip_relocation, monterey:       "92ed57e485086cb1592b260daee7074a94c874dba4efc302185ce0f56e7a0f07"
    sha256 cellar: :any_skip_relocation, big_sur:        "37f5b02a283d076d155fc5d71b87e8aa679505865a004d878a917efb03807d03"
    sha256 cellar: :any_skip_relocation, catalina:       "51352e96579b089bfbb2d424b8e2cc846496cdc8ebb516619831af685978ac7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7f0f860facd133c37bb14e09b0e562ce2de8fcdef2e3faaaf0df91a7f8ab03d"
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
