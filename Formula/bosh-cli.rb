class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/v7.2.4.tar.gz"
  sha256 "7009106227d857792d6d4be37f1fe9668e14726d9c818495f51fb652cec1b372"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb90023fc39da036ac0a30b6869e7513ba992a3b9a3e05f0ebc61a73ba869a0e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb90023fc39da036ac0a30b6869e7513ba992a3b9a3e05f0ebc61a73ba869a0e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb90023fc39da036ac0a30b6869e7513ba992a3b9a3e05f0ebc61a73ba869a0e"
    sha256 cellar: :any_skip_relocation, ventura:        "9cd1bb673166e89d78f01978904871bf89bffc2cb5d88c52e270bcc88a06e4a2"
    sha256 cellar: :any_skip_relocation, monterey:       "9cd1bb673166e89d78f01978904871bf89bffc2cb5d88c52e270bcc88a06e4a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "9cd1bb673166e89d78f01978904871bf89bffc2cb5d88c52e270bcc88a06e4a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "876f6e371083b68bef8bf0321b0755527db48e4582e6cbd5e492582b3e84fcfe"
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
