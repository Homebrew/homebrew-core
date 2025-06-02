class Gitoxide < Formula
  desc "Idiomatic, lean, fast & safe pure Rust implementation of Git"
  homepage "https://github.com/Byron/gitoxide"
  url "https://github.com/Byron/gitoxide/archive/refs/tags/v0.44.0.tar.gz"
  sha256 "1166627cd41daf68eb4e97591cd5daaccf94aa75bb454f657b93766a9bf70da9"
  license "Apache-2.0"
  head "https://github.com/Byron/gitoxide.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86304e974bd41ea30521c61b8404ec459fa0228f986a22c09368cd89ffbe2ce0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b5c854272b3182e3abd2d555b1153a817328e9dad78ba991ecd7b8aa61a7dbc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d85afbabe8fb9f0ff09e2d5f7208645663e1d766897c7c9d3a2935813c222d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "589c23d80b049a8ae104186fcf4b047b5c87102f44e9c1b4764dd3c78069b1b8"
    sha256 cellar: :any_skip_relocation, ventura:       "85ae6e0efb80512f985345886c98c7117a40621a97597852d322c2efd3d22e56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5336edbf824817628bc5900db57cda81f5fbba455ea79509f3fa9fdc4da551b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b245e918ee10027e0e9c70f3cbfb7b5af9419856573e8b3a0bd9f74dfd1230c"
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
