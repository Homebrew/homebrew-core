class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptosfoundation.org/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v3.2.0.tar.gz"
  sha256 "eec2c7535310c05d257b57683c8b241f989f49d397b4743745f314cf5fd1d5b0"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9825965ba05fde02383890a20fdd150dd64db1d70d7e6461d6c686002b703967"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "139086bace19760c3ffb05563ba984d0f6be4f7edd8250c83268e3f1d7a1a16c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55ac5e645c236a67d860ea5b5bb2e13e64819227c28a94515716e4e52778a051"
    sha256 cellar: :any_skip_relocation, sonoma:         "d6301479c9fe37324ed7cc07517792017d5c1e83f752412d584f873944f05469"
    sha256 cellar: :any_skip_relocation, ventura:        "7b3f4e9e7779ba86bfc7dacbf22f36d3416a4d8c355ab42e424c801167b9eb65"
    sha256 cellar: :any_skip_relocation, monterey:       "2a4da5a41756b5edc8acc06e6877a00181ea9ec511b6c76d2a388d75f617744f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae5e94319c543b50c0a79c6b58eec1e401803889b0e7834f4e9da231282a89c1"
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
