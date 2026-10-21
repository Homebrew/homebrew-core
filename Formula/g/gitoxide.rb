class Gitoxide < Formula
  desc "Idiomatic, lean, fast & safe pure Rust implementation of Git"
  homepage "https://github.com/GitoxideLabs/gitoxide"
  url "https://github.com/GitoxideLabs/gitoxide/archive/refs/tags/v0.60.0.tar.gz"
  sha256 "7414812a006ac67d38a8d7e5fa74ebb2863dac10d50fce6cdc2e0c3ddd419f2e"
  license "Apache-2.0"
  head "https://github.com/GitoxideLabs/gitoxide.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "71f521996466298bac404f6d056e8edd3cd9218146d6d29db641f9030f0517ab"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c95fc49d6911d31b7a2a56f59259e7f470f1337b3428513d26c3d0a4bd9b78a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4043ab496ba5cc2e731a9d6e57bf05f47348f28bfc9165536f9290a9f6ae09e2"
    sha256 cellar: :any,                 arm64_linux:       "a6e7d4c3164536940a41a20bc307173e3ab6e2725330cf8167560127875d5aac"
    sha256 cellar: :any,                 x86_64_linux:      "3639fdaf3c44300f95e254350375eac430e295632f48c3cf9275b9337820f7ef"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
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
