class Gitoxide < Formula
  desc "Idiomatic, lean, fast & safe pure Rust implementation of Git"
  homepage "https://github.com/Byron/gitoxide"
  url "https://github.com/Byron/gitoxide/archive/refs/tags/v0.42.0.tar.gz"
  sha256 "4f7febd1bc45d96afc643142d26753ccb7fde7e69f68ca201f04953c1fc6ba7a"
  license "Apache-2.0"
  head "https://github.com/Byron/gitoxide.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "66413371fbb6e945119d644ea703ad6c58c957869cd379b6c201de7dad6cd00b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "480133289233aa243cd9048cedb254871ccd78c3ed20a966ee425d08fdb08afc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "799041e6257ad52e8aa16b3ac2942d5351096b9925fe63da98402fc09f1aaaac"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b889bdaf50135b9d2b245383fac3846874d2bceb3595c2c572b0b26cb63c15e"
    sha256 cellar: :any_skip_relocation, ventura:       "d8efb7d266423ac9a1b6c9d6136eaa8695885ec2669127199ce0bc7703c1987a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54a98bc0e12d5f832baa8412731272902ec4ff451a237db5d719dbbfc68656c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2439117b3363e20b6b5a0cd62ce5e44052b5787955810e9ebb01d87a77b2f1c"
  end

  depends_on "pkgconf" => :build
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
    generate_completions_from_executable(bin/"ein", "completions", "-s")
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
