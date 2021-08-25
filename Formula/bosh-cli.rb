class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/v6.4.5.tar.gz"
  sha256 "035f5ea114e6827e1c84f89333660968d37f143a53b760f7ce7af9d81dc4e35e"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "41c615f20d89b7873c56500555b7bf10b57deedd5823676bafd24099100d6af3"
    sha256 cellar: :any_skip_relocation, big_sur:       "853b5fddb611c1d33d7d66efea261da669933b0d574c4ed4bbbad8a6f054a877"
    sha256 cellar: :any_skip_relocation, catalina:      "5e0123a8a926c12750c251bc396d7d27543e20537350166376be8722a226d8de"
    sha256 cellar: :any_skip_relocation, mojave:        "c97a51a0e35346cb38fd9d8d42ed9bc36b2b063984ca3524f9240d31dd51f865"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3270cfe2c64e2e3164bc16c5b9b75667e3868180548564047af0d2ae988634d"
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
