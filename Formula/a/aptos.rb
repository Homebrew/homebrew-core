class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v2.4.0.tar.gz"
  sha256 "9b4d234bd2c889f9c5900a67ca97205d6e063a078c51b01674703ee98664c6a8"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9aa185fc1327da3429db1370bbd76686f6a3fdbf151a6a828207563aef8cad32"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78b8d23500f384c0b1f4310a8cd858699c1b770a2b4778245d1b51b5207e4e64"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58e65152100bdd85acc1c3a3ad6249eaaab63d036e5949dde26d395a03ac7806"
    sha256 cellar: :any_skip_relocation, sonoma:         "8d3f4b864f36b285f12bb7e80f22c91931602e1ddad86aa97177657001da9746"
    sha256 cellar: :any_skip_relocation, ventura:        "1cf6d0482dc71bceb90b72e8353b0a71ebe533fe2564c72b1e5c89e27e32feed"
    sha256 cellar: :any_skip_relocation, monterey:       "2f387aa94cded0474e077fe8e5bc6dffae2ec7e6afede94528389e2797d1ac09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8235d8dccc09b351865d7eab610b2dec8cfb39120e3ec701ac0a38de541611a"
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
