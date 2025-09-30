class BlockGooseCli < Formula
  desc "Open source, extensible AI agent that goes beyond code suggestions"
  homepage "https://block.github.io/goose/"
  url "https://github.com/block/goose/archive/refs/tags/v1.9.0.tar.gz"
  sha256 "861099541c17548b37b493ef14fe1614409a31b4933f2833e4c486549d4f56d7"
  license "Apache-2.0"
  head "https://github.com/block/goose.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "781903c12086404e9794a7a86fccfb7fb1a48a241db45a2a4f24685756e122b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "055ca00741c3ce97d0ff02bba8554a4b840e9f5b43f62cf7c0f8819c3e1c1f50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc44539cd6844272782c5a3f0236c7ceb846511d9c0e160362b5f7260b9f3f12"
    sha256 cellar: :any_skip_relocation, sonoma:        "29409f45163354fbc1bc4f2d36025dcb0504442c5f053a81b02cf8ca6abc7679"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f33011bef14541227fb1cd88143de14f368fc4ec5b13c2507fe6268cde73ab5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdbbe47a3b4cb6a64dc0cfdbdb6a0499b0c44ddede0b659f4a40a4e3ca116e2a"
  end

  depends_on "pkgconf" => :build
  depends_on "protobuf" => :build # for lance-encoding
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "dbus"
    depends_on "libxcb"
  end

  conflicts_with "goose", because: "both install `goose` binaries"

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/goose-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goose --version")
    assert_match "Goose Locations", shell_output("#{bin}/goose info")
  end
end
