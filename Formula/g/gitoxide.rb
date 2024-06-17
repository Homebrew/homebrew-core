class Gitoxide < Formula
  desc "Idiomatic, lean, fast & safe pure Rust implementation of Git"
  homepage "https://github.com/Byron/gitoxide"
  url "https://github.com/Byron/gitoxide/archive/refs/tags/v0.36.0.tar.gz"
  sha256 "36142c7388c68732a953fcfd9dcd609241b1d9a5d2fdb2e796e987b6b6872fa7"
  license "Apache-2.0"
  head "https://github.com/Byron/gitoxide.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "de2cdc2bcaa3ef267e185258037af946fef84cfda60ddb759caa5474c79664cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6e29464da9e49eb625a021955bf8009605c825d6dd358e3e683a836e8fd4a62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7725b101b42761f336aa0143387ac63fb8d6c2f444bc5305fc05467a52bb42af"
    sha256 cellar: :any_skip_relocation, sonoma:         "f6df12313a72602b20d7c1740c41726bea6d8f6c95e4d7cd42b7e185425153ce"
    sha256 cellar: :any_skip_relocation, ventura:        "616baaff70b465d840a3f2fb4e80575ebc9ca352b14883f9330d03905c6a8aa8"
    sha256 cellar: :any_skip_relocation, monterey:       "dab329cc0f9f6308ee71281223d6e557a5e5719acd6fe26978bde90753a611c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7229a3032f8643795b3688a12c726159cf30d4c0c4c743d187b7b56bca7a1963"
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
