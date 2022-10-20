class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.20.0.tar.gz"
  sha256 "d616b2d28e189a591e777ded4ee52556f632830b410b07830dfd488abbd6e5f2"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9577be7a85176100ebaaf7c9a4bc38357504066650f8e6e50fea55f1e74b6a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "42427ce1dbf46f93abf12aa668310957fdbad55072d23b53695eeb391dafb6f5"
    sha256 cellar: :any_skip_relocation, monterey:       "bd363387e0cdd6f1d231ad52766d351bf56d1de3b1061a2363eae97950f5e7f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "2ac450459a880e6e9fc554fe7e50ba728fee040e51828e5a39dd36741a63543e"
    sha256 cellar: :any_skip_relocation, catalina:       "a67a8143a2270f73502026c0144a80ad9ca2cee7774c91c5c061e5dbb3286dec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0760bb7fa765bdcd0bc8dd40b63400c77aa8c4c643b59ff3cee20845fcb144dd"
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
