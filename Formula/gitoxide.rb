class Gitoxide < Formula
  desc "Idiomatic, lean, fast & safe pure Rust implementation of Git"
  homepage "https://github.com/Byron/gitoxide"
  url "https://github.com/Byron/gitoxide/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "5055074b1dca11bb6ed5ca0b04c87393cf955ca6a536071ea702127cc7907d39"
  license "Apache-2.0"
  head "https://github.com/Byron/gitoxide.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "111aa5f4039392ce477d18fbd3b783ee9601ac8e8c4c97eccf0f9bc7fadb5bf1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b03e4120221f376ccfc3f8207720424b30b0a22a22cc65ecc33ea04dcac15915"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "657928fc9596390c96c099242212d654099830e4b1719a6c970213ad5492e8bd"
    sha256 cellar: :any_skip_relocation, ventura:        "f15e726deb2573cac7f57271276bbdf9c462494cf21f38f59e3427109c1834cd"
    sha256 cellar: :any_skip_relocation, monterey:       "248941f5f1eac48574ca42301cc441809ab2960f4c56975608b8a8f6696337ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "4fec090f08fa5039adc6c8a1faa1e0d56ffa1369d44b5ef01503cd3c2cf3a593"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6270365ea3141a516669c3cf7996f57f0727a7e6af9ca43451ac3cdcf70b98ec"
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
