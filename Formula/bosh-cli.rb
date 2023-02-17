class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/v7.1.3.tar.gz"
  sha256 "2e92afd2d920b182d4aa7decfb7359be685d36cdb71114d0edbd9366f4ca5280"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbf88e434dcaf72c31cd96ee7a4cc5539df8e7022b41ffc0aab02cbe4361384b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f235db5860be52aed25415490637f78fc78531e2383fdec63185e606fa66d059"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "233fc6dad27fbbe15d26a0c3af8c6e3763fad0ede229d1f3aab7f3b53335c44e"
    sha256 cellar: :any_skip_relocation, ventura:        "12efe36a1f1d41b49b293870604473fd2115a14d87de2e86cb57171864801a55"
    sha256 cellar: :any_skip_relocation, monterey:       "9672edffaaa8c529355347035ac22a1e374f6fd06eda31e0b76334256bc8afaf"
    sha256 cellar: :any_skip_relocation, big_sur:        "008598ec302637aad94a51b63c0702cf04e70a677a332cce31705560ec37d1d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88f95b2e2501e3ad21ee317ba7da88c2fb9c0cca2368e848ca2d5e9fb0d631e3"
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
