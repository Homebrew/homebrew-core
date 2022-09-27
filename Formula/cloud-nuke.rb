class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.19.1.tar.gz"
  sha256 "0379c1d1f88d08017aea9a592ea348836b05ae4060e23f15cae9c0650dad53de"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74fac28f159626c752c869126ed96fb10687cfb5014c68eacdb716ceb289484e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "270de53932bebd75b7799725b5402127465b721f23bbd6fc41a5e9e2d150e1b9"
    sha256 cellar: :any_skip_relocation, monterey:       "c9266c9bfc03539a2650796eab44f3c4d23f7c2dac112505740868e05f191583"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba163701443c80783624937c334fb76072f22edf98d70a62ed0c381313919ac1"
    sha256 cellar: :any_skip_relocation, catalina:       "8d202bed099a1c12199f0e379db6043ada4885d8de942091793cd0c9c79e5347"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e15f0c18c3f484e52f21c47691b919277008ed27d8930019d5020015582a113a"
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
