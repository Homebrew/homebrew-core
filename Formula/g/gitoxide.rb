class Gitoxide < Formula
  desc "Idiomatic, lean, fast & safe pure Rust implementation of Git"
  homepage "https://github.com/Byron/gitoxide"
  url "https://github.com/Byron/gitoxide/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "4f074b30830ff37da8ae9de11b0441addea9f1552f0fcac1fa6fb56435d5bbea"
  license "Apache-2.0"
  head "https://github.com/Byron/gitoxide.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cc2a70db9150138c37c3b81338b5c49300178fc5d0e9f5f0fed68a3f31b01ec6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f129e7b64e8dff976a1b3cb8b841d2908a1720b198d8274c1de4f4805c69f320"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11426deae1881a8848d194f27cb3c42099d91fc15ea324e6b0208202d414c7e3"
    sha256 cellar: :any_skip_relocation, sonoma:         "921dc4bb367b5df2c44fe0173456340e2e819a9db7b71b6c56e7d62bfb55e3bd"
    sha256 cellar: :any_skip_relocation, ventura:        "a693f41642be7e60a70e0333bd26954e50f031d6a1e1c5a72611d12e41183f13"
    sha256 cellar: :any_skip_relocation, monterey:       "2e530a9163c6c2232730fbaeeb324f5c0c1b662d349408d9a3889359c948d174"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dab657472de6fd44ad67ff87c9ee5d2c1dab685c5eff683311331ee265227145"
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
