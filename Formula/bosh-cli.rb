class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/v6.4.14.tar.gz"
  sha256 "1e389d16dc981d369fc7811a09f9a4fb0270009ec4fbc6c6f2a43bcc5cfdbc63"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14ee1d016060600411ffe59da56debf21ae678b9135fcdd65eaef064fe648ab3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4de383ce2e3d6008ab7b93103eeab29e2d58ad644e596aa43c22c55a66451001"
    sha256 cellar: :any_skip_relocation, monterey:       "f72a070930a8de0c2e41c214a96885f30372fb3862543648a46bca9ee53fd2a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e9b1295efc551e0bc185bc006831ec9493c1a463a2287fb5d5a715e2186ce10"
    sha256 cellar: :any_skip_relocation, catalina:       "3c6e3d899c2a7acfc760e5c945ced0ba86f9b286cfc6161086d5dbb00fb94694"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4cda5e49617162ec7faf89a9921c3c78d565fa9b8145ff2464f1326403c3e1d"
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
