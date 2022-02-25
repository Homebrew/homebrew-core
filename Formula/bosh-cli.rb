class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/v6.4.17.tar.gz"
  sha256 "d71ebdb783d9694e96db8200c85dab304b55b158daad208ccd8fb8830ab270ef"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d99e2f01bf76cd9cc151bbd9f672abb537aa0d4e50ee3fae5d6a8afa60fd04ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc6fc5b1b291f0967f81be496e441627292f982e6c07c08b411fcaeb28572bc7"
    sha256 cellar: :any_skip_relocation, monterey:       "1a6057650108111857d816d922be984e85e48327b7ce99be3737fe24cf34a7c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "10e91262e5d0b1342e99996990ad246121b8c79286f05500a5eaedade7f82eb0"
    sha256 cellar: :any_skip_relocation, catalina:       "be76ba06ac961629b32879331b2dc5d2d105e02dd213a8c3d3b7ca18936807bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4216b410bc7c149220c48b98602c18749a6272bf2c61bef21631be1ec2d978d"
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
