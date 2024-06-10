class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.6.1.tar.gz"
  sha256 "08e5b67ecbfd7f2e3bee9fff0371f08638ceedc8f3ce443ac81971a2ba6dbce2"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2340a975465871acdcf0ba908f96b6ec0a7e724747a5b9d2afdd5c19273899bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc39843dd04185a309a45efbbd347363ed625f206ef631a6f89e018788d680c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fe4b8de3462d0565a220a5963ace3c7b2e110346c9cb8855c8813be332423429"
    sha256 cellar: :any_skip_relocation, sonoma:         "370ada98b6ce95783615d15cb983673ac78fc82c0a759b03ab6096936b255e38"
    sha256 cellar: :any_skip_relocation, ventura:        "13fe44c5e7ee9802581cab47aa14c3ca2623375e2a98872b129f7bc07a2448cc"
    sha256 cellar: :any_skip_relocation, monterey:       "fd74ddb4d0a1f961c8c05eb926628070451d758cbb561acbffa505e896ad7d84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d51183b2595d49251cec5b82b3ea6de93c3b11c3a52bfdb2551c306d4b77f52"
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
