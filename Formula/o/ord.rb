class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https://ordinals.com/"
  url "https://github.com/ordinals/ord/archive/refs/tags/0.27.0.tar.gz"
  sha256 "53d4e1eed720d307b870e4fd7338727e8e43c15f89c1c137a5c611d9f59df6db"
  license "CC0-1.0"
  head "https://github.com/ordinals/ord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe72bcb4e11ee6515125258ce12693553c1a4fda7f949359f9aef8437753cc6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fecefebc4d07f257e2e88a0228ade1126d99887849c32ec5ba741f255857ca8d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b233fa181e59a89fe2b7729afde1a1514b22a327464045d1864ccd5441ddc615"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e0be5ed13c19816e55dc0de793b6a33fe391c8f22733c11171d39cffaa6d18b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f0fe305ff049803291311b42d24ff999af246ef2d896b02d724917042f62951"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "630a0cf8db8b88dbbbce036bb4e1adfecf6cd31afa78b96755b5a29942cc90f8"
  end

  depends_on "pkgconf" => :build
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
