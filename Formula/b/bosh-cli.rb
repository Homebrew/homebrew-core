class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.8.1.tar.gz"
  sha256 "6136fb2e76345fbd07e03afac15450d8a278c0ead1af97dc5f0361b96d417259"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fa429ad61c135b6a4e449791279e9236fd2376425bdcd2bed2aefbdddcc4090"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fa429ad61c135b6a4e449791279e9236fd2376425bdcd2bed2aefbdddcc4090"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6fa429ad61c135b6a4e449791279e9236fd2376425bdcd2bed2aefbdddcc4090"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4d9a8b1357d68b8f019cbe4afb7ca8db567490ef62094374d576eb52ba9db8a"
    sha256 cellar: :any_skip_relocation, ventura:       "b4d9a8b1357d68b8f019cbe4afb7ca8db567490ef62094374d576eb52ba9db8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6079b4568524d07f3dd9f48d556b4101ab1ea622db0e00df11b05aa712606ffb"
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
