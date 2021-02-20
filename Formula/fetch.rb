class Fetch < Formula
  desc "Download assets from a commit, branch, or tag of GitHub repositories"
  homepage "https://www.gruntwork.io/"
  url "https://github.com/gruntwork-io/fetch/archive/v0.4.1.tar.gz"
  sha256 "f50016bdb2138efdebf44284d75b4340133a670b51a7ba5248fe58f630c4f7d1"
  license "MIT"
  head "https://github.com/gruntwork-io/fetch.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cf261069583f06fe6404096f7f9e5a7a60abbb5619adf1227965758f5a8e61da"
    sha256 cellar: :any_skip_relocation, big_sur:       "af283a1ba60884d6677b139940fa0b4c2e172c52b8e7661963dfd99cd775db46"
    sha256 cellar: :any_skip_relocation, catalina:      "731906b2e52f0b4fbb8a8929ae6821be11b0194b794e716a6747d869eca3203d"
    sha256 cellar: :any_skip_relocation, mojave:        "e52be0f1be40f3e6e67a431b367cb2080cd9ffbe9be7f59d15aaea9d286ac5ba"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-X main.VERSION=v#{version}", *std_go_args
  end

  test do
    repo_url = "https://github.com/gruntwork-io/fetch"

    assert_match "Downloading release asset SHA256SUMS to SHA256SUMS",
      shell_output("#{bin}/fetch --repo=\"#{repo_url}\" --tag=\"v0.3.10\" --release-asset=\"SHA256SUMS\" . 2>&1")
  end
end
