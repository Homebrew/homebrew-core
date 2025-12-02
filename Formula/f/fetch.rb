class Fetch < Formula
  desc "Download assets from a commit, branch, or tag of GitHub repositories"
  homepage "https://www.gruntwork.io/"
  url "https://github.com/gruntwork-io/fetch/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "81086290cc82a990a7369c710179869e3d1a5b3fea60df5997138a96688e9899"
  license "MIT"
  head "https://github.com/gruntwork-io/fetch.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "67c1c63e303407f85f811013248bd0ea071b7f387cf941104d770e3c14c90d70"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e8f939d5d6749844ca829cfb0cca8512c1e454fbb01659c0d2c0e61ecf8f6e8e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0a21b760276b6a748ecb20263b36dc40911a174d471667307aca3f7f9457d440"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9f3c901ec977773483320bd408f284ced92de106232b45469a5e1c241acd7a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9f3c901ec977773483320bd408f284ced92de106232b45469a5e1c241acd7a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9f3c901ec977773483320bd408f284ced92de106232b45469a5e1c241acd7a9"
    sha256 cellar: :any_skip_relocation, sonoma:         "39c52fd363b5c8eaca5e48fe7f0b50a044bc27f3d33542977b2d236fc1f17e4c"
    sha256 cellar: :any_skip_relocation, ventura:        "78d5b3471c78c02528778b3fde16ab9663d1cd57086fdc1b39c80c760e0c88c7"
    sha256 cellar: :any_skip_relocation, monterey:       "78d5b3471c78c02528778b3fde16ab9663d1cd57086fdc1b39c80c760e0c88c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "78d5b3471c78c02528778b3fde16ab9663d1cd57086fdc1b39c80c760e0c88c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "32c389f43f183218777791301e02b1ea30c72ffec7df7cd6978e7d38bf6015f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cafdf23803549e1f8742cebf2e02c01be5f7918e39dd1688a548e652de46d7ce"
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
