class Gitoxide < Formula
  desc "Idiomatic, lean, fast & safe pure Rust implementation of Git"
  homepage "https://github.com/Byron/gitoxide"
  url "https://github.com/Byron/gitoxide/archive/refs/tags/v0.31.1.tar.gz"
  sha256 "639c366d3767f5391e055a985de0ac9142fd56f76a1920bacd920b25dabc3b64"
  license "Apache-2.0"
  head "https://github.com/Byron/gitoxide.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0002d029429c5d05bd11733966a87de3662a7d1fb350cc18896f6b91de044a56"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "120523ded5ebdac8d9cf3f66c37e1b7c45f06ed209ae132221f8de0a1fa80dc9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7778214ecd5a68c3dedd4b71465d1fd23b449a3661456f4052bcec8c7907d855"
    sha256 cellar: :any_skip_relocation, sonoma:         "d9a64bc8cfdd9ecb899356118da466e219ba4144974b57bf395fa05fedf52ed9"
    sha256 cellar: :any_skip_relocation, ventura:        "5dcfa00354034576e0a0504c8e3851d67b0e926436d4daad501cdf60360dcf2e"
    sha256 cellar: :any_skip_relocation, monterey:       "925b025fbf731c681ee37ca312cdfd14083d1fd5525cf5fd9b824724c25dfa79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83733c06a9f100c2d0ea766068e37ca40385cc0c3383dc6b05dc1c078f4d1619"
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
