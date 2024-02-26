class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.5.3.tar.gz"
  sha256 "e602a810a5ffb8db6214d84451795c9c9894cf9bf3ad79b0cd5ccbbfed056253"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "93b09310c321280381fd55e81c8fe9d7d02672623ff25fcc66f2cc10506b1fd9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "856e6828d9c017fd48110ceeb3b4cceb281e4fabdea3bfd29c0b8471cfd9a55d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b65af3a09b02186028b364cd1a3231f999720df5ae5d7dce6a091b1812ac84f"
    sha256 cellar: :any_skip_relocation, sonoma:         "667c1fead44fa0eb54dd87a0a603920ee3ebf46911336d62dd9d40e3e97b952b"
    sha256 cellar: :any_skip_relocation, ventura:        "e56cd5105ace05d5ca143c7ec4e86cd01118c41789a0d8c909b9a14e1695bd10"
    sha256 cellar: :any_skip_relocation, monterey:       "cf73d9b048e91979f774dfa49637ca1b0cc5c8543568a9cb934ed5a0956eb297"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e42c1121a4e2fdd1b4ba1ee776f7627657b0aab7d8a5c7309d558944fa74a9d5"
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
