class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.5.1.tar.gz"
  sha256 "65c19fafd832110cf79d0c16ef4df0a9f6628b5824e7b5c39f2bac32cd53f9b6"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b983f77e7aa2398e4637f313c0682d13eeaa1a33ed02cff770d21b113d667de8"
    sha256 cellar: :any_skip_relocation, big_sur:       "dbbaa05b1c52751f0d6cee69a4d1bf71e7eac92bcc77366ab62b02aded6f4c71"
    sha256 cellar: :any_skip_relocation, catalina:      "0dc586366e3ad7a0d8c575f2e16379e32d2d7a9f74f1d00e49c0e044c5108058"
    sha256 cellar: :any_skip_relocation, mojave:        "7db7089f7af529a14a23d70279b4d14b8e8e7883ba8b572f6c9dbb30cb8250cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be41c72a07ad9430f9c87f84b92bc5f70c02c63f59e6298258ece0e0cde48944"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.VERSION=v#{version}", *std_go_args
  end

  test do
    assert_match "A CLI tool to nuke (delete) cloud resources", shell_output("#{bin}/cloud-nuke --help 2>1&")
    assert_match "ec2", shell_output("#{bin}/cloud-nuke aws --list-resource-types")
  end
end
