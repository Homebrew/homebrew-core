class Fetch < Formula
  desc "Download assets from a commit, branch, or tag of GitHub repositories"
  homepage "https://www.gruntwork.io/"
  url "https://github.com/gruntwork-io/fetch/archive/v0.3.14.tar.gz"
  sha256 "af6513aadf2105bb2355c3b6acc74fa2b12df12d963292750df197b879c32868"
  license "MIT"
  head "https://github.com/gruntwork-io/fetch.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur: "65120b76f68775953d031c64ce61534a9cdf4e1147472a36eb3a26efd361c3bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8f7e8e5825e53aa7a94aa4f8b1d644b96e905aa5aa36801fd7ec3079b4939453"
    sha256 cellar: :any_skip_relocation, catalina: "b8fb96174cd37b851c82fd778a3e8ddf05f38e4e5dac2bd83c105a14ea5999b7"
    sha256 cellar: :any_skip_relocation, mojave: "b82c58ff4af5d06d99bf4f0a665579a416280a7f5df57811f7ebe49b595baded"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-X main.VERSION=v#{version}", *std_go_args
  end

  test do
    repo_url = "https://github.com/gruntwork-io/fetch"

    assert_match "Downloading release asset SHA256SUMS to SHA256SUMS",
      shell_output("#{bin}/fetch --repo=\"#{repo_url}\" --tag=\"v0.3.10\" --release-asset=\"SHA256SUMS\" . 2>1&")
  end
end
