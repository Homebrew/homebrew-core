class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptoslabs.com/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v2.3.1.tar.gz"
  sha256 "d16adce1190d9f23df916e0cead81938784fe485e5beb32d3f9c71d2215a5dbb"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ef99af3048fa497de1ae09d50441eab1ace28700ddf50b2cb1d88b17ffbd96f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0bed4c43016f793ff407b9654a9c4dd753d91f7b52a41f1d86bc49b2ad7efee1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fe2f789cb3ad6897f4dd6a7d51195da3fa139571906a75e47e6f8c0d01d4fc7"
    sha256 cellar: :any_skip_relocation, sonoma:         "791cd05fdd1da490b027fb2f49a2047e98e1f6fbead824c556396207470a2c36"
    sha256 cellar: :any_skip_relocation, ventura:        "416e1d100e5ec59e02d698b550e695cb36b3dfb894bf0bf0f692619432000f63"
    sha256 cellar: :any_skip_relocation, monterey:       "d61cfbbedc39e552bb0b6d575b6358f5a83b24229eed0eaaa6feef85ebbb0548"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffa757f1d26cfc4d964dcbf1b0c395743387bf3cd0c85c2e10f54cff1767494d"
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
