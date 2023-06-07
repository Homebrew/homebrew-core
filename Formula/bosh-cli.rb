class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/v7.2.3.tar.gz"
  sha256 "63bddc0a892e807b262078b4be97d187d12a0f8d49d7c55f26ba904ed41c5988"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01d942eb8a57dc5254d63e63df2115b0b32593234258131a304422840ddb22db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01d942eb8a57dc5254d63e63df2115b0b32593234258131a304422840ddb22db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "01d942eb8a57dc5254d63e63df2115b0b32593234258131a304422840ddb22db"
    sha256 cellar: :any_skip_relocation, ventura:        "84ae655a19e7bc2bd03f3f96cdb0a6d298c9097eec169bde9bdfefc2fd8b299b"
    sha256 cellar: :any_skip_relocation, monterey:       "84ae655a19e7bc2bd03f3f96cdb0a6d298c9097eec169bde9bdfefc2fd8b299b"
    sha256 cellar: :any_skip_relocation, big_sur:        "84ae655a19e7bc2bd03f3f96cdb0a6d298c9097eec169bde9bdfefc2fd8b299b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7043fbf35f838a6aa649ce02274783016c056135bb5386c8b0d02ea83e5f3005"
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
