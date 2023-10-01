class Gitoxide < Formula
  desc "Idiomatic, lean, fast & safe pure Rust implementation of Git"
  homepage "https://github.com/Byron/gitoxide"
  url "https://github.com/Byron/gitoxide/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "779a2203d05c6856c5820f0b97dd384fc9689129213b8b78f27283d6b5ca94c1"
  license "Apache-2.0"
  head "https://github.com/Byron/gitoxide.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9cd80ed4f8c1c9bcbace3f18f87b24fe76792aeb4e1d45c8dfaccd1aee4401d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fc0cd6fdd143f3218892ba59d57df20d737e84c4a3a83fe97e7173c419a9724"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e28b90d9a715a306f6401a1332622888a88f13d515bb298189290329aa4adffb"
    sha256 cellar: :any_skip_relocation, ventura:        "7a7c614909bd3ed52c752b1d2bd001a6821feb0814f749518c3da77eff1d816f"
    sha256 cellar: :any_skip_relocation, monterey:       "c337b306eafc78df5aa59a423774bda6df76934339d0d1060ad9b7e6922cc9e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "993e91f41daaee3964750ce72b5a51bb6f012a42a14c3fc0edb81e0c923a6b2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7abcf9520c4a73a3b9d49cb7721a482dd71999e51d63ac9a5d707ed20a387cd"
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
