class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.5.1.tar.gz"
  sha256 "dd59b747cd178184dff31c7e1707be41f8bc6b412c0c78e62b89aeca4c0f2e15"
  license "MIT"
  head "https://github.com/dandavison/delta.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "22e1edac6c4454720855fd206856e5899db6cbb105f25ce42a1b2577234c0613" => :big_sur
    sha256 "1fffc0f5e4b4bf1b6a280f2af878485e2d74712bb2c591858535d3ea08d51de1" => :arm64_big_sur
    sha256 "08e9ba2ad0cea3a581b5d5831fb7baa50f048307d8428eb72453397f779fc0c2" => :catalina
    sha256 "42e1dab3a528bab5bb09be77d064f303f27939232a7f9fe51e5bf3f616270d5b" => :mojave
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
