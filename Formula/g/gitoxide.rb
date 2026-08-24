class Gitoxide < Formula
  desc "Idiomatic, lean, fast & safe pure Rust implementation of Git"
  homepage "https://github.com/GitoxideLabs/gitoxide"
  url "https://github.com/GitoxideLabs/gitoxide/archive/refs/tags/v0.58.0.tar.gz"
  sha256 "af8210e01903e0995aa5899d8c8cd3f4f2b115ec38a924fa7bf3c7d8ba949077"
  license "Apache-2.0"
  head "https://github.com/GitoxideLabs/gitoxide.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32ca00124fd799e5370a82d2d1dcf562f4de6d6f3e7bc2f74da999b5a7811af9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "099f0bf01952571da155ad4c82fecb1eafe64b1502c1b19eb88d7b1a13504dbb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7238c914d60dcdf930ea33b98c4fc1dc03b1c6c39315b96d2f815276feafea18"
    sha256 cellar: :any_skip_relocation, sonoma:        "992eecad6b1556e41617cd5f5ad5024fdf5351acd3a490100a0b6e7056737c1a"
    sha256 cellar: :any,                 arm64_linux:   "2cf5607c68a23f4dc39793ec845828742e37769c09fb6ebc0f934dc753013a18"
    sha256 cellar: :any,                 x86_64_linux:  "32d500e29deb0aa8afdc809274d934516a239ede6eb1f41ed0a82717a0d4a165"
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
