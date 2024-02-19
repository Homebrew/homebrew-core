class Gitoxide < Formula
  desc "Idiomatic, lean, fast & safe pure Rust implementation of Git"
  homepage "https://github.com/Byron/gitoxide"
  url "https://github.com/Byron/gitoxide/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "0fc1e0f9e36d2622f6a11925607090abf619c73551d2a8f5ea710e97ef1a9eb4"
  license "Apache-2.0"
  head "https://github.com/Byron/gitoxide.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "de55b76cde5237b1898852311820e6c65aeab19b4ed32a9c4f922b58505eabfc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a293a668d6ab1a28eb85eeeed795b03fe1d68e5b0b4822a1577e3661dd69c33"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e0dd1bd0756abc947743f98b7f16875ece3365372c07ceb3f7e0ee84f014840e"
    sha256 cellar: :any_skip_relocation, sonoma:         "87f81a35906e9662377d4500136987711eb8cb5a02bfb7cfde0daaaa5d6b78bd"
    sha256 cellar: :any_skip_relocation, ventura:        "6b2d18393513595d59f00a8a47b958ee63b2a8a98353cf61c99a0f51d943d5ca"
    sha256 cellar: :any_skip_relocation, monterey:       "2964ac975258a5df0e74cf561f49d41d7adc6e474820f9a029d783ad3766f79d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72fbb4ae279cb89733a5807bd50d34f337bc3a5f9bc0c6f7164ba2d11859a06b"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    # Avoid requiring CMake or building a vendored zlib-ng.
    # Feature array corresponds to the default config (max) sans vendored zlib-ng.
    # See: https://github.com/Byron/gitoxide/blob/b8db2072bb6a5625f37debe9e58d08461ece67dd/Cargo.toml#L88-L89
    features = %w[max-control gix-features/zlib-stock gitoxide-core-blocking-client http-client-curl]
    system "cargo", "install", "--no-default-features", "--features=#{features.join(",")}", *std_cargo_args
    generate_completions_from_executable(bin/"gix", "completions", "-s")
  end

  test do
    assert_match "gix", shell_output("#{bin}/gix --version")
    system "git", "init", "test", "--quiet"
    touch "test/file.txt"
    system "git", "-C", "test", "add", "."
    system "git", "-C", "test", "commit", "--message", "initial commit", "--quiet"
    # the gix test output is to stderr so it's redirected to stderr to match
    assert_match "OK", shell_output("#{bin}/gix --repository test verify 2>&1")
    assert_match "gitoxide", shell_output("#{bin}/ein --version")
    assert_match "./test", shell_output("#{bin}/ein tool find")
  end
end
