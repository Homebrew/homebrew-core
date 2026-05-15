class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.10.5.tar.gz"
  sha256 "8d044c13378ec2616436b335ee010320b1f5fa8436ee24aff8aada1005c380ff"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5bcc105df7c31caef931b92aa18bd40112e554498bc04fee3a9e71a34ecae8e6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5bcc105df7c31caef931b92aa18bd40112e554498bc04fee3a9e71a34ecae8e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5bcc105df7c31caef931b92aa18bd40112e554498bc04fee3a9e71a34ecae8e6"
    sha256 cellar: :any_skip_relocation, sonoma:        "854407af01c2ea98a1f5bf588c682b428b8cdb2a6e6052344ca31d74e439e2bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "267999ed68fe0866e9034b9602b16fb7b741d308dc8bed5b92fed9ff8f93b0af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fac3f534314a93d9748b498e9ac909d24bf2b5ef9564b8f75c9fa03aa8960e63"
  end

  depends_on "go" => :build

  def install
    # https://github.com/cloudfoundry/bosh-cli/blob/master/ci/tasks/build.sh#L23-L24
    inreplace "cmd/version.go", "[DEV BUILD]", "#{version}-#{tap.user}-#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"bosh-cli", shell_parameter_format: :cobra)
  end

  test do
    system bin/"bosh-cli", "generate-job", "brew-test"
    assert_path_exists testpath/"jobs/brew-test"

    assert_match version.to_s, shell_output("#{bin}/bosh-cli --version")
  end
end
