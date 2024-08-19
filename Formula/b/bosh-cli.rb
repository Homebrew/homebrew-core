class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.7.0.tar.gz"
  sha256 "027d28852921f05a5b78270d431e6d52eef38c2aeff7b276de97eae95b9683ee"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "297451f2e5cd7555a4f31d439ed8c089ce87b7affb80c675e6a88c1d0fc98e88"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df07175f1f16f459e1f2aa83384feb7f1a5b44a7b0e1ff0e2ae62d522e26b614"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e251cb011061f0f8f1eecbc0d49728e722f746839cd4cd2c9d3bc3af15f46227"
    sha256 cellar: :any_skip_relocation, sonoma:         "fbf3f049d9e63f40f8a71a96c8f2ec0e30ab03c8c9c752bb118ffcff2cf52ac1"
    sha256 cellar: :any_skip_relocation, ventura:        "fcd883bb5f6434ed00e49fcf0c9a78c5cc3db30833b5afa5e84630725dd02701"
    sha256 cellar: :any_skip_relocation, monterey:       "43aa64b97142c6a3d5dc7665b92ffb92c8ba6e6baa0d904bf48c4c8ca6aac302"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52a261722845781d6c7e6f900862ad5ea23fe34db866bcccd27b68408df31f70"
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
