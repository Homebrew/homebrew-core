class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptoslabs.com/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v2.2.0.tar.gz"
  sha256 "7ca866304ac2d2173ac00e758e76a7e98224ac95cca941004fb1a8c12518ad53"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d4d1161888906e6f76a4964a6d4047e45683e2a59c2959ce4a8e3f3d54874d94"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a2d29b57e0bf9aa16a0486db9c5e94729e9646ddad06f54674560ec9abb5a9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10a277d456de7a39065a6b6fbf2067f6ef15588bae9f442b55ae811580888557"
    sha256 cellar: :any_skip_relocation, sonoma:         "d5786758ad85fc31b8babb51c81353d786d4d7d45280c3b19404519ebf8b9e6c"
    sha256 cellar: :any_skip_relocation, ventura:        "75f04c756d578d3c7098bcde6d905a86982bedbc96d68c1b04051d90e122cd03"
    sha256 cellar: :any_skip_relocation, monterey:       "7f4d21a2aecd218205824b50ba2fae96a456d55afca1a5bb7fcccf465ddeaa82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f38d9ca8310fa707008a79f24875c1de91da5c3a67833631969e81ef04c6c34"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "rustfmt" => :build
  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "zip" => :build
    depends_on "systemd"
  end

  def install
    # FIXME: Figure out why cargo doesn't respect .cargo/config.toml's rustflags
    ENV["RUSTFLAGS"] = "--cfg tokio_unstable -C force-frame-pointers=yes -C force-unwind-tables=yes"
    system "cargo", "install", *std_cargo_args(path: "crates/aptos"), "--profile=cli"
  end

  test do
    assert_match(/output.pub/i, shell_output("#{bin}/aptos key generate --output-file output"))
  end
end
