class Gitoxide < Formula
  desc "Idiomatic, lean, fast & safe pure Rust implementation of Git"
  homepage "https://github.com/Byron/gitoxide"
  url "https://github.com/Byron/gitoxide/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "5f0686213fa3ad3d6f3adedf3df463dfdb9bb60f9cad03a174ec6b5adba1567f"
  license "Apache-2.0"
  head "https://github.com/Byron/gitoxide.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8f3e6feddcd6f7de0b15d85c01c03cf40be0a2e0f3d747b72256ee8f33419620"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dbc24a06372d0a2bab0241352847970f5bcfc123084ba1a2e4d570e415144eac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54448eb50ade47c5645064843753686bc5039473073c25ef04b3eaa4631071d9"
    sha256 cellar: :any_skip_relocation, sonoma:         "4913d9d32eb09da5cc90384abddba6e737ae53da740125f28719d64f44ab7e9c"
    sha256 cellar: :any_skip_relocation, ventura:        "80055454f29e4fe63d65b9dc81d2852c712692dab9c30f29c65ebb284f4c4f46"
    sha256 cellar: :any_skip_relocation, monterey:       "19186db63c137fb7c350f6e2f24ffffe7ef4bbe647d790bdd444805cf4133c36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19baaa21e8100d3613bb5c4f6373d66aed8e1e7d8080342c095a6e2a852a0cb7"
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
    assert_match "ein", shell_output("#{bin}/ein --version")
    assert_match "./test", shell_output("#{bin}/ein tool find")
  end
end
