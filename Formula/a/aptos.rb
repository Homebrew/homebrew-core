class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v3.4.1.tar.gz"
  sha256 "84620c3493ac97d422375814c627ccc868b78067b6e00f2d4af9bd83a901b72d"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9e794b424d16f6c6af9601bdfa585dca6b26a3ade04c2a46d1f82f61211f6121"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f83cc3085e4e08113e6a0d82bbf20e719d28e82e0416016da88cd0ee01873310"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77b0d26f377b963699dab5aae6fc9320b4baabb652c8f24b8f598a3617c04e53"
    sha256 cellar: :any_skip_relocation, sonoma:         "47435e65804b71c967fd5ef9b307ab43806ae376e9226b154fd4fa0e54536ecb"
    sha256 cellar: :any_skip_relocation, ventura:        "572ea36b809b57b44e5898f3b6bc6ab889ee01c285ceeca537e913135ad1a2b9"
    sha256 cellar: :any_skip_relocation, monterey:       "651a798e2c9302c602444268b9b8e835e5c99436cf111d63da604fec13861339"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9362e5992a69d7b552b434e78a167bdc00c2637f5d9da2ac4f763d52d3962595"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "rustfmt" => :build
  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "zip" => :build
    depends_on "openssl@3"
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
