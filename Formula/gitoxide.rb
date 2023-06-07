class Gitoxide < Formula
  desc "Idiomatic, lean, fast & safe pure Rust implementation of Git"
  homepage "https://github.com/Byron/gitoxide"
  url "https://github.com/Byron/gitoxide/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "2d26636cfa9f1b2cecde289cf79cafb216baff16221168015137b55dba2eafc3"
  license "Apache-2.0"
  head "https://github.com/Byron/gitoxide.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc3d2038c3ac8f64107e324fbd499f9708c2563331b2d1fde37f2478309b8592"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a14c7edd567db0a0011144b8f046a8016ba141a972d4fe164bcfb6d7a70ff710"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c34fb1f605a8009d91c2deebdf9588c01f828f56626e5ec840a2f64629562b2f"
    sha256 cellar: :any_skip_relocation, ventura:        "28be9f446c6993ead538ccbb15cc52b4262095aaf4941fedb1b70b440ba81d5e"
    sha256 cellar: :any_skip_relocation, monterey:       "dc9a1d0367d53cae700ab81e189ac1d7a458682a855fae84d3cf060f888f1e2d"
    sha256 cellar: :any_skip_relocation, big_sur:        "915886c0556d2ee0c677f018c94922746d4eefd5f23cd7762ff870a71e3fdfeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50e582eea06fbb3e911ecc4f4fbe051b57979e75e31813f042c0f0adbfae3765"
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
    assert_match "gix-plumbing", shell_output("#{bin}/gix --version")
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
