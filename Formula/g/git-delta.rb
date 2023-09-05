class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.16.5.tar.gz"
  sha256 "00d4740e9da4f543f34a2a0503615f8190d307d1180dfb753b6911aa6940197f"
  license "MIT"
  head "https://github.com/dandavison/delta.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "072bdd8b2424a4e874c5240c9eabc1ac2051a0b10ccc9158abc3a576b2d0b8e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5bcdb9902178b0edfe9120cb7eeb07f9a2db90922a785d22a2433dd08756832"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1393d58cedbee7e4586e293fbce648739dc29e4d13e0f331fd306fb40138463"
    sha256 cellar: :any_skip_relocation, ventura:        "6128b49003bcd7e1c5ddd051ccd71a49782d7790bd6e07382553a4a2dbcc0d38"
    sha256 cellar: :any_skip_relocation, monterey:       "16b904194ec5122d690ebc81f12f1fcfc1a61594ac7b2af2364501b40ac7ad9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "abdc4f4b8c20f16126052c6c11f36355aa897758ad30b14b538dbf1de447ecb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19bca273b8a26624a43782b6c6f16dca6eaf661480325f5f65902a7097f12813"
  end

  depends_on "rust" => :build
  uses_from_macos "zlib"

  conflicts_with "delta", because: "both install a `delta` binary"

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "etc/completion/completion.bash" => "delta"
    fish_completion.install "etc/completion/completion.fish" => "delta.fish"
    zsh_completion.install "etc/completion/completion.zsh" => "_delta"
  end

  test do
    assert_match "delta #{version}", `#{bin}/delta --version`.chomp
  end
end
