class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.3.0.tar.gz"
  sha256 "6a7e3d2ed1672eff9938ed4e943e2f82244a2582996d91f91f89c9f1acdac982"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c084670184ec0b4e5b39a53df40c2a6d184c69aeb401a002642543029467a2e4"
    sha256 cellar: :any_skip_relocation, big_sur:       "add3f054eae89487c29b3e0eee890ebb99c335141115184d38480c9cb5f8e0ba"
    sha256 cellar: :any_skip_relocation, catalina:      "dd1ca2ca439053e086c12d6b0f8c1b82564b4f0091d7941f7adeac7c89ae52fa"
    sha256 cellar: :any_skip_relocation, mojave:        "1a1cdb5e0aa36b317c2ec85c66936f6d52aab728356b89de0a0e9d3293b545cc"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.VERSION=v#{version}", *std_go_args
  end

  def caveats
    <<~EOS
      Before you can use these tools, you must export some variables to your $SHELL.
        export AWS_ACCESS_KEY="<Your AWS Access ID>"
        export AWS_SECRET_KEY="<Your AWS Secret Key>"
        export AWS_REGION="<Your AWS Region>"
    EOS
  end

  test do
    assert_match "A CLI tool to nuke (delete) cloud resources", shell_output("#{bin}/cloud-nuke --help 2>1&")
    assert_match "ec2", shell_output("#{bin}/cloud-nuke aws --list-resource-types")
  end
end
