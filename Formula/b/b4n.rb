class B4n < Formula
  desc "Terminal user interface (TUI) for Kubernetes API written in Rust"
  homepage "https://github.com/fioletoven/b4n"
  url "https://github.com/fioletoven/b4n/archive/refs/tags/v0.5.6.tar.gz"
  sha256 "c016fa33229c5be961d0dfe9ab23aede7404c184f59135f85f11af685c43d973"
  license "MIT"
  head "https://github.com/fioletoven/b4n.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6f00a06ea3de3a7ff3d07f5f0726d3a30499c3283fae38e7ed18c5b23013042"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf673d79cbea786c72e2e4ca52e2906856d6aabe997775de130e5049ef0b707d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca72b8cac00cf7c5c86e7ff59f43e7ce3e3b4649f21ab571c7e9a468945d76f4"
    sha256 cellar: :any_skip_relocation, sonoma:        "8fd157f4464039d5200f5020ce581d2b0e373cb529f79e7202d959580b6ef770"
    sha256 cellar: :any,                 arm64_linux:   "6f3efbe0d6628a8a554e596ac7b3a222df66be8be519b907fd2cf4b1b56a4811"
    sha256 cellar: :any,                 x86_64_linux:  "56510a98fe42f0e8b52784af455a7256dc04ddd924a60e0b3ed1e4f84108bda8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # a cli will complain on incorrectly configured kube context or config file passed
    assert_match "Error: Kube context 'none' not found in configuration.",
                 shell_output("#{bin}/b4n --kube-config=/dev/null --context=none 2>&1", 1)
  end
end
