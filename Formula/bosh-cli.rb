class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/v6.4.6.tar.gz"
  sha256 "95f87a0d34be47f32321546b2abd1edaee2cab44c13e1639c9d70fba4a2b90a5"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9494eb0e204d77e53cfd7db9b298ac5a9bdf2857f78adb179869211d0c5776f3"
    sha256 cellar: :any_skip_relocation, big_sur:       "28678d820400058c88da66ba1ec0cc776fde16016414c0dd3821f40387a0cf77"
    sha256 cellar: :any_skip_relocation, catalina:      "9140da7993425d6923704309ffd5e759c4a72e73143082a415b398272d443ce2"
    sha256 cellar: :any_skip_relocation, mojave:        "f9eea7483b4df50c47fc3406c981b655af593e4607cfd0ce2a0f3d0b6cf14c14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2cef220e8424fc2ab994531c1559ba05e97457decff795a4fbee16cd40ab2b2"
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
