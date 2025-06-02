class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https://ordinals.com/"
  url "https://github.com/ordinals/ord/archive/refs/tags/0.23.2.tar.gz"
  sha256 "616eae2491fc825c5936186b986089d862fe11dfba0ff76dbe3aad051e369dbe"
  license "CC0-1.0"
  head "https://github.com/ordinals/ord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e966fc5cb5fd47bdd1b729d23fda7974f6f00961d15fbb9dabb71b637ededaff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76a4c55e1fc38a409d4bfdfaff97cdd5d4d3562601ca994ec7749581293dd0e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b92a683d7d5ccf9815574d1d4dfb25564eb8bef950d54b5bf4ad8b00af6a1770"
    sha256 cellar: :any_skip_relocation, sonoma:        "d845314858deaab37ddee605d7a74b7775baa30d6de62c5304a02d54254d2bc6"
    sha256 cellar: :any_skip_relocation, ventura:       "aa4efd6c738287f86569764f0fa12737c664ef5647f736b37278ec090c60b56a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa0c3208e1c123532495f76c8b496114e78534f42d2df78a5a2b1db8c8abffad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db866e238f99a9627586af9fe21eb3732cb0c842775fc5fb4cc0bb8d9ec77b5c"
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
