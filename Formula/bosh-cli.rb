class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/v6.4.16.tar.gz"
  sha256 "f549ee3359dfe858538989304d0f071783dd682d6101f77c690c7bdb5cd363d0"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d8577ec5528468455a7cd6a1dfe1b464ecb1247e262282357a26ce57378d321"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f154722fdf32f562dfd07b3bcff71208a1d1987cbc4e651ababa597123ff9f31"
    sha256 cellar: :any_skip_relocation, monterey:       "a12f57b12da04dfb1344a00d91be6672327193c0584125b7bc536cfdb38de0f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "8fdc52247d3dd55e842e5f53d719459f7a8882321f11ef474c2dc95deaa798c6"
    sha256 cellar: :any_skip_relocation, catalina:       "40c8051b2f5fa48580e6ca6d832528c59d044204779679dcaba988d34c76d16d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e661336db3b489f5c2a2689a0e6df3f0b8aa6f02c08c6861480e0655082e2d86"
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
