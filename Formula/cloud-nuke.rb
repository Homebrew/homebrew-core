class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.19.0.tar.gz"
  sha256 "e7ada221412aa88619aef52f884e1a60de4f317deb636734e345ba08a035b013"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8df8d54e26e42c5c06653be854d2558119afa0bc3b84f3c03d34d0441ebd7e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a3c8c54c4c0e0a85ab880f20cd9d0856b29182c62645c98fafb33a8cf263ce9"
    sha256 cellar: :any_skip_relocation, monterey:       "18b7cec0e8e456f7a846ab55a641de3b1c00660d4338eb84d5e3adb6e7be7fa1"
    sha256 cellar: :any_skip_relocation, big_sur:        "634688caa9257fd71370e6394deca1e68d25ee9f614b894794f27fc437084e17"
    sha256 cellar: :any_skip_relocation, catalina:       "a21624f32359c0e58b1296d2e825cfbed042799addadcc85ab3141445c7305c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0b2bbb8af379688425bfa124c537f271f7360567eff8c5a7dfab6a54f94c9c14"
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
