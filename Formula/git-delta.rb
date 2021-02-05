class GitDelta < Formula
  desc "Syntax-highlighting pager for git and diff output"
  homepage "https://github.com/dandavison/delta"
  url "https://github.com/dandavison/delta/archive/0.6.0.tar.gz"
  sha256 "27259c3d305edee5f49a3a992e7d739cab400f478a675b7388fef85a2724217c"
  license "MIT"
  head "https://github.com/dandavison/delta.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1fffc0f5e4b4bf1b6a280f2af878485e2d74712bb2c591858535d3ea08d51de1"
    sha256 cellar: :any_skip_relocation, big_sur:       "22e1edac6c4454720855fd206856e5899db6cbb105f25ce42a1b2577234c0613"
    sha256 cellar: :any_skip_relocation, catalina:      "08e9ba2ad0cea3a581b5d5831fb7baa50f048307d8428eb72453397f779fc0c2"
    sha256 cellar: :any_skip_relocation, mojave:        "42e1dab3a528bab5bb09be77d064f303f27939232a7f9fe51e5bf3f616270d5b"
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
