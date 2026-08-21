class Gitoxide < Formula
  desc "Idiomatic, lean, fast & safe pure Rust implementation of Git"
  homepage "https://github.com/GitoxideLabs/gitoxide"
  url "https://github.com/GitoxideLabs/gitoxide/archive/refs/tags/v0.56.0.tar.gz"
  sha256 "97331d654279b8af5d070c6d391c4edc341fa784f5c7e6120278f23b92537c84"
  license "Apache-2.0"
  head "https://github.com/GitoxideLabs/gitoxide.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c2941b71a6d60e1865479b654646722e5d11219d8f3da498a84db86f6d012986"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b672015ab726dd206808d7ad3e47ce0c1eaf6f771b69fa6ffe73c7edfdd37556"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8efb6ad2516ef5a4707b320fc30b44d98ac458ed93bbc0cd52281a8a6b2d140b"
    sha256 cellar: :any_skip_relocation, sonoma:        "7944d7f26ee2fc3cbe8cb0570952dd1bb6e71ba950100568f2450f2a616e44a0"
    sha256 cellar: :any,                 arm64_linux:   "806a24a59d224f5a240e18b1f4e927499178832cfcb57b24bc3014373b4d455e"
    sha256 cellar: :any,                 x86_64_linux:  "4e7edce12fabd68eb1a0971a5f26a8c5e825a36338695f3c5e8e71d2a8b16ebc"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    features = %w[max-control gitoxide-core-blocking-client http-client-curl hashes]
    system "cargo", "install", "--no-default-features", *std_cargo_args(features:)
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
