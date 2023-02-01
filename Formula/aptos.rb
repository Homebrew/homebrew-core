class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptoslabs.com/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v1.0.5.tar.gz"
  sha256 "a02590a83e46f469c1f7850cfc05554677a20e9f2dcdd9892905809cb5f35c3b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77c8a8fb4dee068c4aaa2d7942f5d229a8bc00cad3b4f0ed33a16f5b40a2bef4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "634495292eafefb472f5721fd65d7897fe8d3d641ba6139288e2406ea0219e72"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae9396292c041a1d86ec9f48496699cf4b447518e2c173e1e1ee584ac6ee6a6c"
    sha256 cellar: :any_skip_relocation, ventura:        "f73a8525318ff2b28e0dd40648708e8d249fede1b18629bead374a1ed059f52e"
    sha256 cellar: :any_skip_relocation, monterey:       "71ba38076555732561e65da33972a2662e5a61ca9582d69528a96263427360b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c6f5984158d5acae94be319341712efc661e93405d53391aa9e6947b074227d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1aecba9d95c4cdc04785fbf8da96d74726292468989a830b28c2630c398498a7"
  end

  depends_on "cmake" => :build
  depends_on "rustup-init" => :build
  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "zip" => :build
    depends_on "openssl@3"
    depends_on "systemd"
  end

  def install
    system "#{Formula["rustup-init"].bin}/rustup-init",
      "-qy", "--no-modify-path", "--default-toolchain", "1.64"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"
    system "./scripts/cli/build_cli_release.sh", "homebrew"
    bin.install "target/cli/aptos"
  end

  test do
    assert_match(/output.pub/i, shell_output("#{bin}/aptos key generate --output-file output"))
  end
end
