class Aptos < Formula
  desc "Layer 1 blockchain built to support fair access to decentralized assets for all"
  homepage "https://aptoslabs.com/"
  url "https://github.com/aptos-labs/aptos-core/archive/refs/tags/aptos-cli-v2.2.2.tar.gz"
  sha256 "c10424c40aa96c4b4bae8b0211fca9cb0e308df5dab37b746d2986ab157ce63c"
  license "Apache-2.0"
  head "https://github.com/aptos-labs/aptos-core.git", branch: "main"

  livecheck do
    url :stable
    regex(/^aptos-cli[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2f4fed33a4ca444ad6fe516bc2b1e6568c2527c5064ccb29ea0ae4133f5010af"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e09ad451b58833a6143fda6c1e7c997255ea66a284e1fa8f98432fe1f030ba88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86a790e65729ebb9a6c2dfa9a5ac12a53ae2e528c70c27310cecdab1e7bece30"
    sha256 cellar: :any_skip_relocation, sonoma:         "04d5adf2aa68eded68ee5b5cfe9b0db01ee1cf5dfdca634068f953af9a8cfa65"
    sha256 cellar: :any_skip_relocation, ventura:        "c7a3c641f443964466b3ca870652a8b9f271e8fd50a42ebff11b1b718ad3eaa4"
    sha256 cellar: :any_skip_relocation, monterey:       "5d4214e0a74028548035b8862a5585b43228eab7ada4cc906ed982d320f3dc51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0696be1ffa9aa5190353d2fb8b95be1f5cb6e2acec3d33a3ccaf1205241519fb"
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
