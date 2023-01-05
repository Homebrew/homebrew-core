class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/v7.1.1.tar.gz"
  sha256 "f975d357b49aaf60334ec9fbcfe79bd3218ec6650e794228ada40d7516ddc676"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c759a06acd06bdd93b4ed96233a303787e7a2d4d79c8a02190c51ee82a3a6b65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32dfd228577be4f1b97e282f2ea5e9aed4736bef1b9a9f2aa35a74eee8b9c5ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5416b237ffb7127ad4f36e73cc413838744ea4252c26c5cd00f55283a56ab506"
    sha256 cellar: :any_skip_relocation, ventura:        "a727a8f218a0647eaed3bc564ff3ce3b6c7eb6c856a20dc5db6bf82131a9377d"
    sha256 cellar: :any_skip_relocation, monterey:       "b36785c7e4fa223cb2961207cce17cc87d61ab570903bf36b7098afdea0e960f"
    sha256 cellar: :any_skip_relocation, big_sur:        "c601435a945d4ddf14dd404c3dbb6224f4b59832c6718c95efeca8689c4b0f25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c734bac37df1625e5e5df5ea3fbdf4ac3df309e297c71cd2091df47956a809ef"
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
