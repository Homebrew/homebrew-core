class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https://ordinals.com/"
  url "https://github.com/ordinals/ord/archive/refs/tags/0.16.0.tar.gz"
  sha256 "f2d89cbcb78948e5906659702928e87abb2fec3d4c620de67db23fc8c2ad5fbb"
  license "CC0-1.0"
  head "https://github.com/ordinals/ord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "36dfa61e24b70b433fe05cbcb94cd075ee2cd89ba37264b970cd91d83d08398c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a85a3fe2b7806089d2653f1c66f5e31e97947ebaf8577b1048da74088cd0643"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47ec55d66f3a00720b600bda38ca6681b42b08dbda36e17e5786fee88cbb62d6"
    sha256 cellar: :any_skip_relocation, sonoma:         "cae2831dba442b5c934dcc3efa58716f2404a9444993ebbcf11523709fdaee2b"
    sha256 cellar: :any_skip_relocation, ventura:        "39594cca657bc367481b6cf6ad0ff163169c8e30ab0567ea4e7c34c12943d98b"
    sha256 cellar: :any_skip_relocation, monterey:       "506888401e4bf8123d37ad9143e32c0ed62238d0fc2c5e851bccbb06bfdb7dc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "534e5cde4c029c251cd926ee1c133f7216c74a80ab21264a8f6e82d36460f0c0"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/ord list xx:xx 2>&1", 2)
    assert_match "invalid value 'xx:xx' for '<OUTPOINT>': error parsing TXID", output

    assert_match "ord #{version}", shell_output("#{bin}/ord --version")
  end
end
