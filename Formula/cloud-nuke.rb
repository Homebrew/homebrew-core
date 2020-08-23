class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.1.20.tar.gz"
  sha256 "9a8df713129afe2c4a536dcf3286353ecfb1899655efb95a6608c078cc66f89e"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1bd062358ee79ddd80e6aa82b70586c35e5db0f5578e828534186a2945114be2" => :catalina
    sha256 "00d0e25987130eef854be69b476785b5c9520c010462b152435aa6a406098c2a" => :mojave
    sha256 "a7a6c5ebabdab4c70e408d12dac4798d675dcb067de4e342d08c9d8a894ea9b9" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-X main.VERSION=v#{version}", *std_go_args
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
