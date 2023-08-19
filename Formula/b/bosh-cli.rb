class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/v7.4.0.tar.gz"
  sha256 "2a3fcc5e42736823d4b6652406ccd9d66d063836907475e82143dc470bbd81a0"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f71b952cb42f4b64142d2f7ce09e2129a61e29007813e34fa67f230efaeffa86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ddaf1ac25ef48d604ae88006fb25ebb376fb2b2106224204fb99f1587c9b2a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "934034a4dabcaa39611e11b44602050009adfb5d01d0f077f3f1ae1e600f9bde"
    sha256 cellar: :any_skip_relocation, ventura:        "aa219f2bf563642e05ac39d8f8765f700669187e4df116fb43ecfea92a9deeb5"
    sha256 cellar: :any_skip_relocation, monterey:       "b8371679f15706423c02c462bcaf6babe6b699d94c68c526c2a4e83e16330673"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c34fef716599c71035f947f666720c1e8b863fc735f85a8f5e673c9c51b9cf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b4b55b2a7985a8211e7d258cc6d54266adcd59fdd0b076853297a111d11c3c8"
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
