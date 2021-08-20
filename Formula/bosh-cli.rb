class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/v6.4.5.tar.gz"
  sha256 "035f5ea114e6827e1c84f89333660968d37f143a53b760f7ce7af9d81dc4e35e"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "750abacbf96ac11668086f5ed9c53ac4fa83ffea19c1b95d46753ad10b94dc71"
    sha256 cellar: :any_skip_relocation, big_sur:       "fc0dfe5f6e06be0f3a76f9648e9c43a2d5e1de5ec51ea7ed0691359b8b2c33c9"
    sha256 cellar: :any_skip_relocation, catalina:      "91f00e9bd5e20330c8be9cc13a2a62e2cc205645d2d5e08dea91dd800c76eba2"
    sha256 cellar: :any_skip_relocation, mojave:        "5176e503a56dc61fd3e3458e10ef7a7fff24698adea343ad48d5a889b7c3e419"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c8778d0a08809d95405e343688b9760cc561e7886698df53ac579af60ed0014"
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
