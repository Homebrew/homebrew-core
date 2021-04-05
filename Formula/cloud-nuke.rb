class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.1.27.tar.gz"
  sha256 "484d56fa848964bd1f351a344de0aab4886a781b9c8141e1860080641486cc5a"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7233106996c97ef0c8f2be3cbb2d5e01c2f80c4c3a0f4e271e2488762e62d30e"
    sha256 cellar: :any_skip_relocation, big_sur:       "0f8b32380b7088d257878257d36dd32f02d56f99a308c19c181b13076e174c3d"
    sha256 cellar: :any_skip_relocation, catalina:      "a3a3734608d0cc6537f7420c1e981076e40dec3c6f6af845e6aeb2f7ad799de7"
    sha256 cellar: :any_skip_relocation, mojave:        "9aa96b94063fec62d4686a8211d329901128b50b539bf7a144377694641f5fda"
  end

  depends_on "go" => :build

  # remove in next release
  patch do
    url "https://github.com/chenrui333/cloud-nuke/commit/5f2919c.patch?full_index=1"
    sha256 "049a8e9dfc5715c8cb322b53ea76f17192ba46342a0d09cd39d78324ba138cfa"
  end

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
