class GitXargs < Formula
  desc "CLI for making updates across multiple Github repositories with a single command"
  homepage "https://github.com/gruntwork-io/git-xargs"
  url "https://github.com/gruntwork-io/git-xargs/archive/v0.1.2.tar.gz"
  sha256 "4c72733190db0b1bc07677384e0b8e99f97b21a43211cbb7ab25d407e72795bb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a91a6466ad070fc69f12a1d668e247f6f188a8f81be279c24e1faf920fb21186"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65ac686c223cf8e2a017bbae360e49a19bf718a73ad224a3e8461838c5bc9993"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3afe28990642017552b421f0cc4db21052d11e08946d88fb7d82ad940f9e524e"
    sha256 cellar: :any_skip_relocation, monterey:       "dfab7b1158e46ae606493165040a902d4157e4df3417974309915067c9404d27"
    sha256 cellar: :any_skip_relocation, big_sur:        "587dbaa57efeb4c3a28a8b3d274dbbef2cdbcd423dbb59db880386d5742e51cb"
    sha256 cellar: :any_skip_relocation, catalina:       "a6f32d12b1c6096404d33ab66528b0d6beebf2a69d94c422baaafe0d27d3685e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ded4e7469bf3c94622ff26f37955b15ba3f29cf96e89f64a47eaef4e0cf1f4e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-xargs --version")

    assert_match "You must export a valid Github personal access token as GITHUB_OAUTH_TOKEN",
                  shell_output("#{bin}/git-xargs --branch-name test-branch" \
                               "--github-org brew-test-org" \
                               "--commit-message 'Create hello-world.txt'" \
                               "touch hello-world.txt 2>&1", 1)
  end
end
