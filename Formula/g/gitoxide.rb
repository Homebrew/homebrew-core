class Gitoxide < Formula
  desc "Idiomatic, lean, fast & safe pure Rust implementation of Git"
  homepage "https://github.com/Byron/gitoxide"
  url "https://github.com/Byron/gitoxide/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "6c90676da83e4aa202ac08c6ce849d31031310953569d5fee7529437778b6273"
  license "Apache-2.0"
  head "https://github.com/Byron/gitoxide.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb8050d4425d912cd1f3f4086edfaecf2c4f121d7fa18dc54031e21a9daf78ad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8e9bae4ec05925941dd7bae2e48cf2c6a9ffc5850fc9d450f8c355a6552855c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87f71424ebdf5fb2d0ead00bf2d01723af1b8e8a5e220fdf663dcec03ca56c28"
    sha256 cellar: :any_skip_relocation, sonoma:        "46055b3c76f98f108c9375b16d120acf9f225200bd5302e6adfe6a30fec85b1a"
    sha256 cellar: :any_skip_relocation, ventura:       "1ad3b26f2bff32d1aa2d27f3c31ed3cea75768172823db4f77b2bc896c525dd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99b0ef44d392bd2a63c1efc14335960cfb5a50595a8c874b6093b1abe046b973"
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
