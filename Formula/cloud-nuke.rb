class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.1.30.tar.gz"
  sha256 "5f79e00b32bfba7e669127e50adccb6d21c0f8351d66733bbfa7bddd5d8653a3"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b17a2693f46142381893f00f7988d4296c024a7ba4852585aa6cabfa529c6bf1"
    sha256 cellar: :any_skip_relocation, big_sur:       "d81f003fc6993caaf897faf962124152ada062fb27c5da3b4c9e84736a087d4d"
    sha256 cellar: :any_skip_relocation, catalina:      "f4f321b0756b3f831e79017b3336a92cd77c572d885f862f5c0213d65fc30134"
    sha256 cellar: :any_skip_relocation, mojave:        "c86f84dda85f2952a53cde639994392bc19dff6e545eee44ebabcbc2fb100c27"
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
