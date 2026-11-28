class Imagineer < Formula
  desc "Image processing and conversion from the terminal"
  homepage "https://github.com/foresterre/imagineer"
  url "https://github.com/foresterre/imagineer/archive/refs/tags/v0.25.1.tar.gz"
  sha256 "16ed8ebe47f7af676b333a8abc11bf60b0ab490bbda0de9cf8a04cbf50d5f8c9"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/foresterre/imagineer.git", branch: "main"

  bottle do
    manifest_sha256 "196658ef6c9834a46ba33ac6d2d486e249026f4eb7f2ac5e1cae66d67ea958a5"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7ada417e06a5b52199491b90c658c0ca86035cb107bba8e0482169e34382d2a2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "00367057842b1f302abb944b53da00977ff54fca5d96e949249db9120707745e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c5c9856905ec63041ee0c0d60e7d42352fa63be836d37431430fa6bfca5f98a5"
    sha256 cellar: :any,                 arm64_linux:       "81ff1c4d0b0fb01bb85eee2c791ec0076b1e2688261da074e2695aa1ddfb318d"
    sha256 cellar: :any,                 x86_64_linux:      "ad7fc51a92a5d1b27103840c17ec81e0ee6714d7237a3cf6a412131e1181ff4a"
  end

  depends_on "rust" => :build

  on_intel do
    depends_on "nasm" => :build
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ig --version")

    system bin/"ig", "--input", test_fixtures("test.png"), "--output", "out.jpg"
    assert_path_exists testpath/"out.jpg"
  end
end
