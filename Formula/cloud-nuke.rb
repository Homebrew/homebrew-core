class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.5.0.tar.gz"
  sha256 "4b2f5bbdfe4f483b8a6998c08bbbdc3d03ce4afeea5c85bb3b1aa51cd9eefc32"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "30e9cdf35ad1ac1d5fc4c50f7b901c69a271ec8db7241f37717a413d9b98e0ea"
    sha256 cellar: :any_skip_relocation, big_sur:       "87a0fee8fdf24b8910c906eefe544931a97f868eae1ca3ad20dd52e2d01999d0"
    sha256 cellar: :any_skip_relocation, catalina:      "2f3e8948f3c3cc78408c4e8e97ded60443fcc197e587151602ce85ea1dd49688"
    sha256 cellar: :any_skip_relocation, mojave:        "5ea7256e794635e85aac46781097ee8c8a95eb090de88b4d714de845e3abff08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8afc35e7ffe69f3a0060e6ba2853530089a0856b960cf6e9cbd4b4c495e538b"
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
