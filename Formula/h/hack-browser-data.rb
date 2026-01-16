class HackBrowserData < Formula
  desc "Command-line tool for decrypting and exporting browser data"
  homepage "https://github.com/moonD4rk/HackBrowserData"
  url "https://github.com/moonD4rk/HackBrowserData/archive/refs/tags/v0.4.6.tar.gz"
  sha256 "3e4d70e0b6a1b0bc1e55d6caf1a5b8e84c1115f381aa14b382b358a01eb3b30c"
  license "MIT"
  head "https://github.com/moonD4rk/HackBrowserData.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf5e0e28a426f13b59544ca0843c67c5706df28db0a87aa9a64b2b1f0fa89752"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf5e0e28a426f13b59544ca0843c67c5706df28db0a87aa9a64b2b1f0fa89752"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf5e0e28a426f13b59544ca0843c67c5706df28db0a87aa9a64b2b1f0fa89752"
    sha256 cellar: :any_skip_relocation, sonoma:        "a14333355a3288098948e2f776dd61f0846b95e7d9a77ad3593701625c4f8274"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab15db72f8c0abd86caa4bec50a2d736ab839583ba99ca69bca6d6b62099624b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4abbd72a5a012a3d006be2fafdb7437e73bac360fa51c200384f2df42f790f7f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/hack-browser-data"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hack-browser-data --version")

    output = shell_output("#{bin}/hack-browser-data -b chrome -f json --dir #{testpath}/results 2>&1")
    assert_match "find browser failed, profile folder does not exist", output
  end
end
