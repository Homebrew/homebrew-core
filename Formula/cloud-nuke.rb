class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.26.0.tar.gz"
  sha256 "da5455b516efd6be81e2b9ae25b933575eab7d88bc8ff89b91ae171023d10e31"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1f5a8149717796e974eef6d1746c39bda938dbf316df3c514bc4f52d27e8f51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d3cca3ff923bdf2099bb479ef87c0001dc18df64cfbe960074028bd7a4b8921"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2c5e632e67a4244010419ebc8a8ef6610defad0eb09c8f4df584d137775bdf40"
    sha256 cellar: :any_skip_relocation, ventura:        "2ad5912ec9e7c8b13c078f7d72bdb7c254fd4f53c44f87e1236508187212378e"
    sha256 cellar: :any_skip_relocation, monterey:       "92fdc9de3f26d30cc8bfca2b1d1d69c79674af571390c7cfed49984853cc9633"
    sha256 cellar: :any_skip_relocation, big_sur:        "aef8c596b8b467c87420a86c28bb4efa7621d8cfb39ade859f81a9f09f6a4734"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8468b8bbf3af69f11f2c7c594c398a3194312a2f0b7b918af8b98a1f8fabde1f"
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
