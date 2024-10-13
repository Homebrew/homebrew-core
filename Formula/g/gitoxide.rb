class Gitoxide < Formula
  desc "Idiomatic, lean, fast & safe pure Rust implementation of Git"
  homepage "https://github.com/Byron/gitoxide"
  url "https://github.com/Byron/gitoxide/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "1bdc30bafdd3605d6e278aa5562f772a9732bb07ced9321ea31893b28f950c0a"
  license "Apache-2.0"
  head "https://github.com/Byron/gitoxide.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4d38ace0bfddf96b73febebed8c568da676716414680b1e0a4a2e51be57d084b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5d1a313698094658289fc0a08f74598024be8b561c5918061595870438b21e68"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "325b88fbd3e300b983c3241d28b6d2ea347f6c0f5a3f43e14af759ea0dad1060"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e8c33358ea506137433a52bd344f25787410abfe509fe9baad1e3115641f82a"
    sha256 cellar: :any_skip_relocation, sonoma:         "f1796a56008907c6ea97777e05c11206b5ec50b26c78fec5258113aa95443ddb"
    sha256 cellar: :any_skip_relocation, ventura:        "f0891096bf35f06324b9d6123e70da27095f313c8601407e0273562566b24888"
    sha256 cellar: :any_skip_relocation, monterey:       "5d1052f4f559191e6ebed1ec285540421bd01c724a057b9169ab0d7c5a9be4e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "581675565e5c35638da08093e6f272ec300201f055875ac99a947b9fa18c0c33"
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
