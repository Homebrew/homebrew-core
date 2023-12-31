class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.5.1.tar.gz"
  sha256 "8d9ec645ae90a0dda9454781f707e2dc53543caa609749f5a055356d5d8f864c"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ab6f7db5ca1ff3a74b42768a1cef29d036b1068c8d46c1d64a99ec70eb57d2a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4bea9a290a5ca4fd47053bb838c09580138e425a50af371f89e3f75c632b6126"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7b54982bb71e7ee9b4ed51099dec74c504d48c8b0841a1612eca7bbcc62fb596"
    sha256 cellar: :any_skip_relocation, sonoma:         "abcefa1f35ab48a1f586e7b0fa01c42b4cf3d18f5293a1af4a0a00caa38cb579"
    sha256 cellar: :any_skip_relocation, ventura:        "d5f08aa8c659de298e2125e6a3ac20f2a1901e0cdc612609c62fad850609610c"
    sha256 cellar: :any_skip_relocation, monterey:       "90227add572fdcb70d341fd6405100b04c17bf6cf87a7799a280bbd46b1bcbd7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fccc6ce4c227d119a3ce94d6bebee6287fe76ae69a4d1f9c9dceda784fe7ec36"
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
