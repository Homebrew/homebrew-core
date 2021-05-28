class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.8.0.tar.gz"
  sha256 "706b55667de221b651b0d938dfbb468112b322ed41a634d3ca5c8bd861b19e8a"
  license "MIT"
  head "https://github.com/dandavison/delta.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "028874b198dcfafdc9df029ac5e3f9df9c22969e10f6552a8fa9681905fe3633"
    sha256 cellar: :any_skip_relocation, big_sur:       "2c0b4c2decb0c447cdf66bcca647251e6ccc3684f5a060a950c7645c047e1a04"
    sha256 cellar: :any_skip_relocation, catalina:      "adf32ac4190cbf84233ab11c9ee0f39ff8698221fc81ef09f2dcf604631d062d"
    sha256 cellar: :any_skip_relocation, mojave:        "158e488f87574ced953ebc9b8d4de54ba2206eda1d3bda950ad39f9ab303e9e6"
  end

  depends_on "rust" => :build
  uses_from_macos "llvm"

  conflicts_with "delta", because: "both install a `delta` binary"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "delta #{version}", `#{bin}/delta --version`.chomp
  end
end
