class Gitoxide < Formula
  desc "Idiomatic, lean, fast & safe pure Rust implementation of Git"
  homepage "https://github.com/Byron/gitoxide"
  url "https://github.com/Byron/gitoxide/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "ca83828c96e2a24936dce0b5328f1e5962a56378ef3ae36965a3391ae7e993a8"
  license "Apache-2.0"
  head "https://github.com/Byron/gitoxide.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4e655491c869d8088164c32c58d996b5c19235cba284ee73dc988aefc758c1d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5474ca14c684098a78021e43fe9b65111a874243439f95bd56215b11cce41e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "743134d88b3f531033b2609ce3dda5fa66fc1b8357a5d84e2712e961c8d4e5d4"
    sha256 cellar: :any_skip_relocation, ventura:        "f5b50e30d3bc7cb7aed8c1422e772397af39eb79440c8a085406af6f3c351196"
    sha256 cellar: :any_skip_relocation, monterey:       "fd8325a4a15c2c985d2b59b33e9413099ea08f27a29ef83822796b32769f4667"
    sha256 cellar: :any_skip_relocation, big_sur:        "43cc7e3ad079ca6827c1dc8f73e11985939370980fb64a0c401f2edd6480f11b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4c5c4e31a1266030f576e8be676ce4277e4d9a049af8e1bdb7ddc83c2eb823e"
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
