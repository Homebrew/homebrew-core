class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.11.2.tar.gz"
  sha256 "7b7ad5dc71b368f934e13aa7986876742278ea7fb1adee387ac38e328f8b71f2"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab2792f961efcca65e598e6ef474ee4d519bbfc7dcd49b4b876633d9efd24987"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8618026ab9f0b80b1fea53b038217284ad19c9f91d0f84362e2dccf118b35dee"
    sha256 cellar: :any_skip_relocation, monterey:       "8ffef9ad2d1c86aa5769a140e4250699fd111b89927aff7616bc13f5b7a8cb2a"
    sha256 cellar: :any_skip_relocation, big_sur:        "16861cf0af4fbbc3a522013ac4c04680b665fbd0623b150be461076fb8eab12c"
    sha256 cellar: :any_skip_relocation, catalina:       "b866350b104a9c0d5b1155c124c844bfe8de306998f9dcbedf4027afef9b2840"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7246d75a0b9f99b1709f7486496b5808ba46303aca1b352b4b6ee166509dc7e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match "A CLI tool to nuke (delete) cloud resources", shell_output("#{bin}/cloud-nuke --help 2>1&")
    assert_match "ec2", shell_output("#{bin}/cloud-nuke aws --list-resource-types")
  end
end
