class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/v7.2.0.tar.gz"
  sha256 "35d1f3d276c6a0e9d48be39f910408e6c2e391d93c2df7f6c1d6a2e6912102a4"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50f8825886e046a53f80886272c66b9c42254cec57141e0ad2974c372d020612"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50f8825886e046a53f80886272c66b9c42254cec57141e0ad2974c372d020612"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "50f8825886e046a53f80886272c66b9c42254cec57141e0ad2974c372d020612"
    sha256 cellar: :any_skip_relocation, ventura:        "81a6602675606287a1fc3c7bee64d465aa01c96305b2b652f5c7c8dd08c8fa70"
    sha256 cellar: :any_skip_relocation, monterey:       "81a6602675606287a1fc3c7bee64d465aa01c96305b2b652f5c7c8dd08c8fa70"
    sha256 cellar: :any_skip_relocation, big_sur:        "81a6602675606287a1fc3c7bee64d465aa01c96305b2b652f5c7c8dd08c8fa70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "499fb0e6a18905c0fa276b6a14ea6e788fdae46baea64c327381238cb97d3d1a"
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
