class Gitoxide < Formula
  desc "Idiomatic, lean, fast & safe pure Rust implementation of Git"
  homepage "https://github.com/GitoxideLabs/gitoxide"
  url "https://github.com/GitoxideLabs/gitoxide/archive/refs/tags/v0.55.0.tar.gz"
  sha256 "7274b65864995a3a889be69c571507345e5c2a748498e7fdcafb9924c1f89eb2"
  license "Apache-2.0"
  head "https://github.com/GitoxideLabs/gitoxide.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ebb95e02395be772291b9f5e1669d297359b2828875b29dc15fec532db296df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "418d5d3e08cdbf4d5ce7af8fe16b1182c373016ce1f164ae53cb52b7447b87d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ac413cf8bd9d6c492e938fd60b9270649ba2ed87c70726822bed8beb144fc026"
    sha256 cellar: :any_skip_relocation, sonoma:        "692b9d5d5c7ef742711ec91af666f4478df770d0e398c83f42e3d2fa5f5472d0"
    sha256 cellar: :any,                 arm64_linux:   "dbc35d0a8a0f549bd71483da4bc2c91e44274c77ee8554853ac3363c35104d0d"
    sha256 cellar: :any,                 x86_64_linux:  "ad832498b72f09f53d419be63467e24197f21e25164a845b1b8d846852528047"
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
