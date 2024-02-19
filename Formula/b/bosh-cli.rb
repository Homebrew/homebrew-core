class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.5.2.tar.gz"
  sha256 "3a282ec27f20847ef50458a23ade75c9d81c9412b12e0501239c280eabc12ecd"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "010713bba59b97e61b9d4b8c5d6e678d392f15d69ae4f962eb90da2568f16b4c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bdf52b06c8131ff66619c127316c7f6ada10636c0e3343501ee51f586089e43c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b76b94927aa59720fc18b94011f60ffaeb6e75a66a58843a7b1236bd9435d36"
    sha256 cellar: :any_skip_relocation, sonoma:         "1f7a333897671630ca76cb8f40b8f9b76edd60256127c0d1f68acc079ad21bc8"
    sha256 cellar: :any_skip_relocation, ventura:        "f133933b86f53f5dfe76cf5b85265cd7bae2101cc8538c8606e762247ea7c38b"
    sha256 cellar: :any_skip_relocation, monterey:       "cb91f20372f66852823634d59cc76672f9ce4df092f24d3557413d4fec0d60be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0697aeb82bec9ff9ca68db0ba092864e417be8250e4f729ae3b4d349655a01e"
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
