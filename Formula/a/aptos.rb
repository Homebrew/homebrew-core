class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v3.0.0.tar.gz"
  sha256 "7bce85a5613299137f40c8de5661109187faab09093f5412dd146e0e20f73f68"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb9c7868aa29db39ba4a9a8b28a16ee30d044a5ca44f3dc6d8a91539822c93ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9aeb5aa50f9a944780cff75cad8c12d80ec6295b6dd799f43f496f754352a737"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e1cce45714fdf665df9972c574cd197d7b2f788a81ca08d64c6e450c30f1cb0"
    sha256 cellar: :any_skip_relocation, sonoma:         "fb6b1f90d17b40eefe3c8937f17baaaddf88d7b00139c1e1c936c4b8769d8454"
    sha256 cellar: :any_skip_relocation, ventura:        "c3ab073dd78025f97d78ed752019a335a22a40bda4c8cff8edf7885f29b403fc"
    sha256 cellar: :any_skip_relocation, monterey:       "f270d60046b426015a74457b49d6a39dd78562a50fbf3b643c081f508b71e3be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "751e2dd30529ab2b955d994359ed21ab4bf8bb9404cba5913815a8be89aba3c2"
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
