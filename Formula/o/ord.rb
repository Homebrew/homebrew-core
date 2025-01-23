class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https://ordinals.com/"
  url "https://github.com/ordinals/ord/archive/refs/tags/0.22.1.tar.gz"
  sha256 "36f7871915d9c0f19d3fb47e49a54ce2d07d5df04f48744616158680b7d3d941"
  license "CC0-1.0"
  head "https://github.com/ordinals/ord.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6bac82b73a8cd9dfea6e4c06fd5310bfa601f4c6f52b494a8fbce90190c99cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1ce4fcfa4e8836fd6f896e84d1c09e0236bf892973e3880fe022850a89c3a7e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3d56a59a656189fd6d2cb63f7f3b5b37ae928e0f7b2fd8cfb1cbac2571599b7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "7eba326305a05cb9bbb0de9f094f0b5964979728e04d78f1c94514932b8c9d3b"
    sha256 cellar: :any_skip_relocation, ventura:       "8edf20146b0761a3949f4f98bd165ffe4314eb931af274e0a64c351ace5eec22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8f6555295dc68be47ae9b561ff2df4e26d00ba323ffb85f25d3d29735b2bbcb"
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
