class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.9.1.tar.gz"
  sha256 "42e58077df1b8d64155c41efbd5bb4dbe30745ed2f5098fd405a811ee6fead54"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55347ee20c2afd264e760b56c06c141c646fab4d71147350813fefd9c312e10c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0798829f26ba7e08e6b2eb54e39f356bb5b186c2e7ff4edfa15df5e031b9d9fe"
    sha256 cellar: :any_skip_relocation, monterey:       "261597bf6f9555b5866399a3f47e6285f6cd37db01c9c93d602068150d85b89b"
    sha256 cellar: :any_skip_relocation, big_sur:        "46744ef41635a11fb3df8ec54259906a4fe448f6f4dd07362b1b8324047d8c44"
    sha256 cellar: :any_skip_relocation, catalina:       "32d1f357e118c1b82aead283998b2d134a76bbb00f74f0cf2681ea927b236901"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63f7d55e081bf8109ffc0fbdfda40f57f6cf75b28fc23e144df81771f0fc2e36"
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
