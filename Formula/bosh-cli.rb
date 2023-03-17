class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/v7.2.0.tar.gz"
  sha256 "35d1f3d276c6a0e9d48be39f910408e6c2e391d93c2df7f6c1d6a2e6912102a4"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "788abe4f2dcc7e63e83fad97f3bd659324ea2ff987a658de78c8e82ddd12e130"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "788abe4f2dcc7e63e83fad97f3bd659324ea2ff987a658de78c8e82ddd12e130"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "788abe4f2dcc7e63e83fad97f3bd659324ea2ff987a658de78c8e82ddd12e130"
    sha256 cellar: :any_skip_relocation, ventura:        "de8e5377af87ef668d270c4f8a52443cabc836b9558f42d9433823e5cbd7d45d"
    sha256 cellar: :any_skip_relocation, monterey:       "de8e5377af87ef668d270c4f8a52443cabc836b9558f42d9433823e5cbd7d45d"
    sha256 cellar: :any_skip_relocation, big_sur:        "de8e5377af87ef668d270c4f8a52443cabc836b9558f42d9433823e5cbd7d45d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "149aca8b4459a70d330a108d6599a97d30cb9a9160b90f8851dc1bfbdbd259d4"
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
