class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/v6.4.8.tar.gz"
  sha256 "fd45680cff13b2f6a9955d10125ec56fc2a0419c2f224842c528286ff253dd81"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "660e222f9b5f49313d636461f7209c803c944feb46ce253fb040e30bb521aaf7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa30f58eb0828e81a70e0fef0a5e2790831df51eb498efb996ac87a99ac5d6e6"
    sha256 cellar: :any_skip_relocation, monterey:       "93aea4476b8b31ea46adfd49d3c514f66664288f4adc269caf508a812c5b8e27"
    sha256 cellar: :any_skip_relocation, big_sur:        "439143a165d6a27059f3a8c00f202ffbcc3571c402165ead3175d5ace6d9ff74"
    sha256 cellar: :any_skip_relocation, catalina:       "63595dc60f22449d0c30080414cde7949343a9f9198b7cbc165e0d5d422cea2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "689d92f9fcb1cce3de2262e17d425c3c37c363292c712203c6d4cbf4d7a64776"
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
