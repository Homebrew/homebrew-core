class Gitoxide < Formula
  desc "Idiomatic, lean, fast & safe pure Rust implementation of Git"
  homepage "https://github.com/Byron/gitoxide"
  url "https://github.com/Byron/gitoxide/archive/refs/tags/v0.33.0.tar.gz"
  sha256 "0fc1e0f9e36d2622f6a11925607090abf619c73551d2a8f5ea710e97ef1a9eb4"
  license "Apache-2.0"
  head "https://github.com/Byron/gitoxide.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c4997e716e9625b77d790197fb59f379fd93a0caba33be7fe698371fe5bfe551"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46eb62cb4619e061ad3523d8272b7a3d6198e32dbb36e4e3b349b7e25c2c0c58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb805809b3db7cd626e3bc2e69770a541c5644db6594e3ec334c6f4eee86b211"
    sha256 cellar: :any_skip_relocation, sonoma:         "5a72b5cba190b3b9602c8cb103f27218a08c2244a4172e638595891bc5f2960c"
    sha256 cellar: :any_skip_relocation, ventura:        "e1e3160d65c2f907d87a983608829b40cb062f217cb81b58b6067a2df907ffee"
    sha256 cellar: :any_skip_relocation, monterey:       "e6169e9629243c7b97068b4d5765cab929320bbfc861b9ffc3627a6be32a95a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e53c5fcc3648cb45cf51748f95c48afd01bc7bad551a9954663db2ff5d12fabb"
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
