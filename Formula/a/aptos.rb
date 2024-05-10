class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v3.3.0.tar.gz"
  sha256 "bb5071a1016b5ad22f3d7a2f9357f0661c86a986bfa6b9cd14cfe145eed531f1"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0f82c6fc3a039ad3582ed86904febd5b1494297c5d52fca47f003416dfda2cfa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "681825ae2bb585b1eba92d860a0d3be0f1136a0a150136744694506a09585eb8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee622846198f0a9858da104799ff6df3df2614466a2f76ea11edef0d5e652ffd"
    sha256 cellar: :any_skip_relocation, sonoma:         "cf8a1ae27de2ff60e544141af22c1d6df348822c471fb05e01371ef01db20d79"
    sha256 cellar: :any_skip_relocation, ventura:        "7f51f7ee6d71491786db915093090238ff75203a8cfc3712258d0cb58b2021ef"
    sha256 cellar: :any_skip_relocation, monterey:       "df730b055812a7070235a627fffc1b851d8d94359ea85c720272860289b32ea2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04a54e8dabdde09236209e602822f1837d46254b3a86143163e9e51c5b6d98d1"
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
