class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.2.0.tar.gz"
  sha256 "3949e9b4345e088906e2af472c951ec12ee5e0c582add3b0c39eac15bbf6975d"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "af12dea60e894df260e12fb281befdca83ceeb29d95235b6ca7f82e74efeecbf"
    sha256 cellar: :any_skip_relocation, big_sur:       "6ec739fadc9ae6423b94f400cac632a524d5484f4cf3ec8d198b3622fc6b74fd"
    sha256 cellar: :any_skip_relocation, catalina:      "20a887ea78779cf126585fd7c0020b36c3d3545c3f57b8d0137d5da5d57aceb2"
    sha256 cellar: :any_skip_relocation, mojave:        "af204a87970fceee89f2cebe941b4784a78c38a80b84e8c8d5340b5a7b2be26b"
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
