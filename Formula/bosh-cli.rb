class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/v7.2.2.tar.gz"
  sha256 "41b5b50b6687a851b712d6a8d64cca1ea42f3f68a215967e8d8512405733588f"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25e3329beab9d376f1d70e82798938120ad5f6d3c04099f2b459a35aacf25627"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25e3329beab9d376f1d70e82798938120ad5f6d3c04099f2b459a35aacf25627"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25e3329beab9d376f1d70e82798938120ad5f6d3c04099f2b459a35aacf25627"
    sha256 cellar: :any_skip_relocation, ventura:        "83093c3a49d50e99d8cfc2d65043ea063b1258b68c463f8b57ae30f9cb461887"
    sha256 cellar: :any_skip_relocation, monterey:       "83093c3a49d50e99d8cfc2d65043ea063b1258b68c463f8b57ae30f9cb461887"
    sha256 cellar: :any_skip_relocation, big_sur:        "83093c3a49d50e99d8cfc2d65043ea063b1258b68c463f8b57ae30f9cb461887"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3b7ef77bf89437e09d52886017e19ebcd1286096652424c9a182a1a109f9abf"
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
