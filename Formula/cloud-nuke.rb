class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.11.2.tar.gz"
  sha256 "7b7ad5dc71b368f934e13aa7986876742278ea7fb1adee387ac38e328f8b71f2"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "585c38cd6fc35fd70f679d7641a7f29a7621b99d6bfef3526ab1c04d1e76b71f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2b1c8814c00e987d7dd0c1c9e12e9d5b052c2c6c8a62ba7929e4c5b5db6ed5d"
    sha256 cellar: :any_skip_relocation, monterey:       "88e0ca1f576bb4f2de48c7d3cf5c76592693cf09835a2a28a148e0c1906086b8"
    sha256 cellar: :any_skip_relocation, big_sur:        "007a7b5715ffe9db40c8af65e41c4f1a29b7a8a0377c18afabf46cfe6f35a4fb"
    sha256 cellar: :any_skip_relocation, catalina:       "7e9226bd0b05570209c744b577601a2abf8f5690847055d94b188337962d2774"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19712c3c8e0c7e3078672f0e497c2392309ef10a9f45ec5d8bcd30e86d5363e0"
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
