class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/v6.4.10.tar.gz"
  sha256 "1d16660f0eeca65bb2ab5a814b1b5c6fba82a09af1f4a6f65cc8075d10bb721a"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac3ea504654761fa876cb56c352af1dcfa933a69afab531b7170c9d1008b2d2c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd870da444df50bd5eb206783c4de8c7c3be9f66052b1f338d33db4ba4bde653"
    sha256 cellar: :any_skip_relocation, monterey:       "ab6a15058abccd6b09efc2626c3d7db74965c0d3166b494ec44bed1f634b51a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "eaef653872ae5b40c8ed810a3ee78c28b442ccb0a392ccc80d79a6be005f1b0c"
    sha256 cellar: :any_skip_relocation, catalina:       "cf1d738769f4bad5f330705eaf272981ca435ab159eaec327c37e95e450fb0fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b00ec7ad0511811c543014c93bc42ecbf445b22f77efa0fc6d5659d5cdef063f"
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
