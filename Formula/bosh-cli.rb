class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/v6.4.13.tar.gz"
  sha256 "f5c61ab0d863668804e06491ea8c0b6de41d58d30a1b0c63c2e519f5bfaebc9a"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6c2a7dd2a57f97cea7c064e28053364c5934cca9dad089e74d89895a9e7b7be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dedbb97a1e78ae66a3a76c1de5a03babbb283753782b9ad08af0a908804ca6a2"
    sha256 cellar: :any_skip_relocation, monterey:       "bcc7eacecfb85717d4876e9c58a2fc103a91369964b5e85a7b85995eec01e6ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "71f45f1968514d0cd51f0f103dafb7eb6a27d9e41b11a4cfb5a39760077c1d37"
    sha256 cellar: :any_skip_relocation, catalina:       "ae86733716d0af7893426e2d7e4871eb65981fb18c5f01a9827ee2ec16ecab8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa4bd505928feca1984ca4ffc6d9370af50e33d42505f2a33728eb9598c0436a"
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
