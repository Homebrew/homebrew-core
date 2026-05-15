class Gitoxide < Formula
  desc "Idiomatic, lean, fast & safe pure Rust implementation of Git"
  homepage "https://github.com/GitoxideLabs/gitoxide"
  url "https://github.com/GitoxideLabs/gitoxide/archive/refs/tags/v0.53.0.tar.gz"
  sha256 "81d99c6b60cc93a01dc7539c310e3e8737fe88dd86ee8887cf203ba7b76aca59"
  license "Apache-2.0"
  head "https://github.com/GitoxideLabs/gitoxide.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9c7f0a1d78e7300b276464d40387610becd9cf50d396b680cf51d57e2c834441"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7e7a14c02bbef4a610d9181f578b78d8a2f1492408861abb0b869b1dbac4727"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7539bdef763875e0efe0f6cf1740e9f5cb41afc02da746b45a4d02ea43988e02"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0ba7e0c765ee5ac1451f32b449bc68c8ca19f85885429ceaf89171f34672d13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6fca26bd86396904ef6794cc2ce6fdb3e7c9acf0e48002693c065fccf3172ece"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df1731cda13cdf4294bf9af42ff9ddfea88651e2af30e57988cb7f267eb6955c"
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
