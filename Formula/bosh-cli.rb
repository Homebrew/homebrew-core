class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/v6.4.11.tar.gz"
  sha256 "f5d0af6af086c227be0caaf8bc06113355d0bf9bbc258cec33ecbb2c9d29fd10"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3883139cba0611c50b6280133d3e36b763ce9b37284ca9885b66ef7429a60391"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38951e2ea47d0a4af129464751003833e5e4436538b2d1df3390539bcbec6f98"
    sha256 cellar: :any_skip_relocation, monterey:       "6e54299698242ba37f3391fb629d93bc478464a91aaa233382a0f989caee1296"
    sha256 cellar: :any_skip_relocation, big_sur:        "8cd52aa155b2d88a08bb4f3f250813ace7f9fa307af7fc32969ff6347d029102"
    sha256 cellar: :any_skip_relocation, catalina:       "630c68ab8c3143b8f80a079548a3bdc0a76a960e5ccc573426e05b01913971fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d6c67e95443006891a046f9f2e354781248e12df38039101e6d2b2182492faf"
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
