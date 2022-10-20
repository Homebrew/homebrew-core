class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/v7.0.1.tar.gz"
  sha256 "28eef4aebcf522c3816d21872f25b8f51891a1dba9fa32a0ae22be48ae94d35b"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "391527c415a03be10db868ce2ce154e3dea9f9884de069aad790e808ead86e9a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9616a48000079fbb18677c7a50e34fdbb0af4124dc87ad87fc0f9a76d54eb775"
    sha256 cellar: :any_skip_relocation, monterey:       "4f3fe55f35b43511008df3fc525d720702449ce3e1a711b83d00a3fd8d05b820"
    sha256 cellar: :any_skip_relocation, big_sur:        "ffa104acc9785622b7bbb6c7856740f77afc060cc0359bbd6aad522213475d0c"
    sha256 cellar: :any_skip_relocation, catalina:       "47a0028a5e80d589e01bf29768888116f7ab633ddd6cceecdc0740de854da548"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcb764849673bf311b11ca85e4664816e742f91cfd6fa7cbfda784a098221a93"
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
