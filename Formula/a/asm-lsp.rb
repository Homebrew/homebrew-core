class AsmLsp < Formula
  desc "Language server for NASM/GAS/GO Assembly"
  homepage "https://github.com/bergercookie/asm-lsp"
  url "https://github.com/bergercookie/asm-lsp/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "9500dd7234966ae9fa57d8759edf1d165acd06c4924d7dbeddb7d52eb0ce59d6"
  license "BSD-2-Clause"
  head "https://github.com/bergercookie/asm-lsp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9dbd0fa7b74cb1681084b66a3734930224775007d96d00d31bf14a24ba018941"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1438e57e7d525aad8e337a2b8048956ffab380f8c6ca0f67a57ed6f9d9148ebd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8466388eb30846c764f3b866085c171dbdeaa5b35f2db7358daafe42e3b8a6f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "847db26465932b751aadf74a7d26ccf155ea0788c5120d3440747e69059b38e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4044b50207f4e70ad533d93f322202a80f52b4a55bd046de5b3f9b039d539d10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76259656f79fee2add9b11db2439511d8eef903f3bb3419d889262fa486b2892"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "asm-lsp")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/asm-lsp version")

    expected = if OS.mac?
      "Global config directories"
    else
      "Global config directory"
    end
    assert_match expected, shell_output("#{bin}/asm-lsp info")

    output = shell_output("#{bin}/asm-lsp gen-config 2>&1", 101)
    assert_match "not a terminal", output
  end
end
