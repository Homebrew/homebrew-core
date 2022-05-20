class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/v7.0.0.tar.gz"
  sha256 "febb3e575bf86305e17eb1f520bbb5f8cae6284e832660e6ad0e8f0d54dc5228"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3dcb91010cbf391be2a590cabfea690f92e3d3c17fa760a7009ef92857338058"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1cef0fe5fe99d5860ccc27905c45d48115b4c3ce4555dec4cc65f64a88f7f146"
    sha256 cellar: :any_skip_relocation, monterey:       "59c2009ad2cc5e37fd7197c2215cf26ec78a1200981e93fa13272ee610400368"
    sha256 cellar: :any_skip_relocation, big_sur:        "29182c031aff1b8646d025fadd060fc814fec83c6c9bd4c282c5de00477d08be"
    sha256 cellar: :any_skip_relocation, catalina:       "e34c90845644e3277e0b2f7763a70dd5f945db175ff839ecd4a4610e4bedaf5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6a382bc3c2548212df61b7c0ebf60c17aa7e16737195d20beb93adb33c3e75f"
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
