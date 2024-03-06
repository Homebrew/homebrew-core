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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f7c735ff214a42712502557ea198064b194ef0b4577c78c56231957d5dea0119"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53c5eecd5137f532523b2cd2350b03a4c0a60a7eaed3723df503bb9466af6992"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76c28ff93a88f60137e317b7bb640ebf579e3cedbfa56861fef06ea9aef3e345"
    sha256 cellar: :any_skip_relocation, sonoma:         "7b126965cd721dc3cc75f1189908b23d24c02fbec79227797803c361519cf941"
    sha256 cellar: :any_skip_relocation, ventura:        "c59e7bf7e0105184f9b137f1884ae6250c038cd5e53e271c5f066e01506bee86"
    sha256 cellar: :any_skip_relocation, monterey:       "7d48dcfd4df1d3cd4410db990d624a6458f3e0c2b53c813e2ea19a1639161322"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17985a0807c2283fd329f78b6c45c983c7abbacb2e601b3ca7ee4fb960313138"
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
