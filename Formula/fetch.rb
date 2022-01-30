class Fetch < Formula
  desc "Download assets from a commit, branch, or tag of GitHub repositories"
  homepage "https://www.gruntwork.io/"
  url "https://github.com/gruntwork-io/fetch/archive/v0.4.4.tar.gz"
  sha256 "5e5af89111a2e986d7d59c156c55ca301c9f2199369c9dc89b80dc94cb62b31a"
  license "MIT"
  head "https://github.com/gruntwork-io/fetch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4107e5ba168a30b083ef1e868f405d68d2ae823b1fadb92e2f967dfe3de7b94"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41302187efc88f0ead1e3274615d5a5099b79f8cd8e78fc9728da52260f8a338"
    sha256 cellar: :any_skip_relocation, monterey:       "d1108cdfb654a6b1c900d79149b359c64e4c837aa5d38fe012115cfc890bd545"
    sha256 cellar: :any_skip_relocation, big_sur:        "a79784fe018af23a3866358f66d5fb44ae8696cab834d500d364d42eabcbf368"
    sha256 cellar: :any_skip_relocation, catalina:       "382428577c8ab2f1305918a09f33446fb9b0441d827747d9cf0c9d96c572d745"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eed1540bc4b522561c4ae714464b8b7f5bdfd7cb544c6dc933e72035f6fb7c56"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.VERSION=v#{version}")
  end

  test do
    repo_url = "https://github.com/gruntwork-io/fetch"

    assert_match "Downloading release asset SHA256SUMS to SHA256SUMS",
      shell_output("#{bin}/fetch --repo=\"#{repo_url}\" --tag=\"v0.3.10\" --release-asset=\"SHA256SUMS\" . 2>&1")
  end
end
