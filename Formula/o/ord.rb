class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https://ordinals.com/"
  url "https://github.com/ordinals/ord/archive/refs/tags/0.29.1.tar.gz"
  sha256 "58aae0aa6bce2cb022de51a9c0e36d4185945eabfb202e764bf1230aa564cefd"
  license "CC0-1.0"
  head "https://github.com/ordinals/ord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "feb807887702429fd13df6bf5200a3d40b81661f036e3cf39e63e19401e45040"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bcaa804722edf48ae2ea0168957fb27013f1c7e4ddfff7d11997b7d97a7a7baa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e2648d262b9c0bf85ae5a027480b038a23c351dff1ff5040bc6160433410996d"
    sha256 cellar: :any,                 arm64_linux:       "f909eef225c193c254758e71bd0d2d760d0109e486b96b9cbc5cb9617520022e"
    sha256 cellar: :any,                 x86_64_linux:      "88812edfe4feef99ab05c792b004c1b103dbe91816c173a970e55fb4dd7b74c3"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/ord list xx:xx 2>&1", 2)
    assert_match "invalid value 'xx:xx' for '<OUTPOINT>': error parsing TXID", output

    assert_match "ord #{version}", shell_output("#{bin}/ord --version")
  end
end
