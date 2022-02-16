class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/v6.4.16.tar.gz"
  sha256 "f549ee3359dfe858538989304d0f071783dd682d6101f77c690c7bdb5cd363d0"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96bbd449f42a6ef58066b4d5e2c703705e114d1653740676e96fbe26efe7dde4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "293bda4169c91e7cef40a39dbef8af5fd1d71e5eba6a522b093834fda0ad6bb3"
    sha256 cellar: :any_skip_relocation, monterey:       "be3a744c55f802f59dbb93661fd429cdcd299f306567807a450fdefdf703b7b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "032933921adcd9662867abe24793f97f795c4138ae0c721bb9e9af4b0d541c37"
    sha256 cellar: :any_skip_relocation, catalina:       "9b64668066f71eeae71e52197e766faec26a28e0e707af39cedabb8d12a28004"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "593620c34dbdc2303743fcbf1eab0cc281e4607be04c8e57e0b9da2006a84a47"
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
