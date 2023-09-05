class Gitoxide < Formula
  desc "Idiomatic, lean, fast & safe pure Rust implementation of Git"
  homepage "https://github.com/Byron/gitoxide"
  url "https://github.com/Byron/gitoxide/archive/refs/tags/v0.29.0.tar.gz"
  sha256 "9ef3a8fc44ae28ad17ccff393ed0d46e2d117f1090c8f31cd3a4fb3d7a975d5d"
  license "Apache-2.0"
  head "https://github.com/Byron/gitoxide.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f2e835fee4c960466d228bf760837af123c90142eb6a1fa1ef4fcb5f4983fdc8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bd754970c9e3928524459b92f40130e0111883134f04bced90af683f7a4b190"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "841778854dcde90a2dff6670c52cc2fbe39ec276bd17cbff78234b6dc8ae10c7"
    sha256 cellar: :any_skip_relocation, ventura:        "3661c1b7c002c2a7c93c6719176cdfdc09f0798bbf740473c668ceb0e3f242a4"
    sha256 cellar: :any_skip_relocation, monterey:       "4cfaacb4184d343e7c9a0dd49f36739c14d32fd0f7504fbf59ffef3e2ef69aa8"
    sha256 cellar: :any_skip_relocation, big_sur:        "637ae5a16b4d74648f63f9121fe4be98109330b8e9b8bc307e345c9d370ca5d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa676ecec9f3c29d316bd670c6f84566e5c3c00e6b2d7fcf346cd07132b68a09"
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
