class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.27.0.tar.gz"
  sha256 "e9dbd708223e115c6b9e179df3e8280df865e41e2a82aadfbcbe68b6b0d1a305"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78fc3b95a2c0c6c7e9a0333a2615ad36494b1041077722cf7a17ce3f09578de9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7220ccfd0d2fda8744815b3983bea6385dec9c7954047545e703429c002d51da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c26e7a810b11af8e8c767d904b0998ffad677650beb417afdb70b6d9ffabd5b3"
    sha256 cellar: :any_skip_relocation, ventura:        "b9b09fab38b8a297adebf176d14268f6ff5d2de29e178728310efe1da49645c5"
    sha256 cellar: :any_skip_relocation, monterey:       "b908211a2929f71519c34e8c015af21b68151384b8f544dcc402e551fa641a94"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce6220e831c7d58e252c7ee5d922da1eb553a7b1c69ff6e5d815d9793877a059"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5acddffd14321092be2a06b0dc8b563653e5ffad35136d1ef65605e4776db5c7"
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
