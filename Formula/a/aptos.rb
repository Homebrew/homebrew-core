class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v3.0.2.tar.gz"
  sha256 "34cbd3bad135408961c538ec8d452ae7cec9b5c7dd6a69c20097b68c6195d665"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "33597eab1715635a733389899e634e345dbeec8ffc6b97586bf8b2e5e9824dd7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef107c1a158459116f9652eeb8bb8f5fa789c6bf942c840c5319844e87811116"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41cb93b82044a5334b1e453cce12024d8ffebedddd8ca26ebf96f82933904575"
    sha256 cellar: :any_skip_relocation, sonoma:         "5bea9f9f5c574f925c1ef7fc9b333d6157321be24984c41db67e4eaf59e0abe2"
    sha256 cellar: :any_skip_relocation, ventura:        "05bc77750223d5e50a355d5efcbcb571615acbd507d2751d3a1f6bf210d09442"
    sha256 cellar: :any_skip_relocation, monterey:       "61c7a07dd67814e49cf531ed79e3fc95a4264d7d47368cc4204ca54772d37d80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6516a012475af4651208a2bedea235172e7f3e6e4acaa7b071800c08b2940a1"
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
