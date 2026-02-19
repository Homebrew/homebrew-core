class Gitoxide < Formula
  desc "Idiomatic, lean, fast & safe pure Rust implementation of Git"
  homepage "https://github.com/GitoxideLabs/gitoxide"
  url "https://github.com/GitoxideLabs/gitoxide/archive/refs/tags/v0.50.0.tar.gz"
  sha256 "8ad0fdcfa465fedac7c4bafaae2349ad0db7daf48a80d9cb2bd70dd36fa567aa"
  license "Apache-2.0"
  head "https://github.com/GitoxideLabs/gitoxide.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fff3fbbab717f66e5cfdab3b8afac7785e0a8b7db9bd92faceb5b122b309ec3b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a0d77684b1696f916b1f62c3bc9a8b5ece788eb2536116d9f99bb3afe3dc6d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fb56c3597edbeae9069270fd1d0634b0b7220e673a0b71ca1538c37206e0eb3"
    sha256 cellar: :any_skip_relocation, sonoma:        "80c612d0ab04a096f597ce3a9385eee97e84900380b7d6fff7f444dee54d40de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "90a8b9597271e0b679508710821c6642adb8837c06d4977d750d52cc28107f51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb4d0270e3705b880377f3302798fdb4a726391cb929395a7b0719d378c2ec03"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    features = %w[max-control gitoxide-core-blocking-client http-client-curl]
    system "cargo", "install", "--no-default-features", "--features=#{features.join(",")}", *std_cargo_args
    generate_completions_from_executable(bin/"gix", "completions", "-s")
    generate_completions_from_executable(bin/"ein", "completions", "-s")
  end

  test do
    assert_match "gix", shell_output("#{bin}/gix --version")
    system "git", "init", "test", "--quiet"
    touch "test/file.txt"
    system "git", "-C", "test", "add", "."
    system "git", "-C", "test", "commit", "--message", "initial commit", "--quiet"
    # the gix test output is to stderr so it's redirected to stderr to match
    assert_match "OK", shell_output("#{bin}/gix --repository test verify 2>&1")
    assert_match "ein", shell_output("#{bin}/ein --version")
    assert_match "./test", shell_output("#{bin}/ein tool find")
  end
end
