class Lazyrsync < Formula
  desc "Terminal UI for rsync, written in Rust"
  homepage "https://lazyrsync.westpoint.io/"
  url "https://github.com/westpoint-io/lazyrsync/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "e8995ca91c75dc67d88ad4e09f74a2f7863387262b63ee299833a4f9d4c7de3c"
  license "MIT"
  head "https://github.com/westpoint-io/lazyrsync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1289bb0c1c943be2d68a3ddd8e4e3750cd4c30b4030d07421418d9a4f62cb294"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0737a2af17f71489ec35ece6ce7e0bee6d22be9ed3c6249c9fae16845ff47ebe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0f602436b219253bd93db59a106d22463055e013ece0c6f22c44cbf5ba222802"
    sha256 cellar: :any,                 arm64_linux:       "80c062866d5aad2319c2ce1594e61118c43588d4864de74b4c049d051801143a"
    sha256 cellar: :any,                 x86_64_linux:      "2cb1b95de9c14c4715d4563dc6282692dac7ba062da7189f8eaf88fa5dd80232"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lazyrsync --version")

    assert_match "No profiles", shell_output("#{bin}/lazyrsync list")
  end
end
